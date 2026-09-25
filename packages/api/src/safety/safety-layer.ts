/**
 * Safety / Rules Layer (SPEC §35.2, regla no negociable #10 del master
 * prompt).
 *
 * Independiente de la generación del modelo: los engines (nutrition,
 * fasting, training) llaman a estas funciones puras y actúan según el
 * resultado ANTES de persistir o devolver una recomendación. Nunca
 * depende de que el LLM "decida" ser seguro — son reglas deterministas.
 *
 * No diagnostica ni sustituye atención médica: cuando detecta una señal
 * de riesgo, bloquea o redirige hacia consulta profesional, no continúa
 * optimizando el plan/entrenamiento/ayuno.
 */

export type SafetySeverity = "info" | "warn" | "block";

export interface SafetyFlag {
  code: string;
  severity: SafetySeverity;
  message: string;
}

export interface SafetyOutcome {
  allowed: boolean;
  flags: SafetyFlag[];
}

function outcome(flags: SafetyFlag[]): SafetyOutcome {
  return { allowed: !flags.some((f) => f.severity === "block"), flags };
}

// ---------------------------------------------------------------------------
// Screening de texto libre (notas de check-in, descripciones de comida,
// contexto enviado a adapt_workout, etc.) — la única superficie por la que
// un usuario puede escribir algo que el resto del sistema, basado en
// campos estructurados, no vería nunca.
// ---------------------------------------------------------------------------

interface TextRule {
  code: string;
  severity: SafetySeverity;
  patterns: RegExp[];
  message: string;
}

const TEXT_RULES: TextRule[] = [
  {
    code: "acute_symptom",
    severity: "block",
    patterns: [
      /dolor (fuerte|intenso|agudo).{0,20}(pecho|torácico)/i,
      /chest pain/i,
      /(no puedo|dificultad para) respirar/i,
      /(me desmay|perdí el conocimiento|desmayo)/i,
      /\bfainted\b|\bpassed out\b/i,
      /sangrado (abundante|fuerte|que no para)/i,
      /(dolor|hormigueo).{0,15}(brazo izquierdo|mandíbula)/i,
    ],
    message:
      "Describiste algo que suena a un síntoma agudo. Esta app es de bienestar y fitness, no de diagnóstico médico — buscá atención médica antes de seguir con entrenamiento o nutrición.",
  },
  {
    code: "self_harm_risk",
    severity: "block",
    patterns: [/quiero morir|no quiero vivir|me quiero (matar|hacer daño)|suicid/i, /want to (die|kill myself)/i],
    message:
      "Lo que compartiste sugiere que podrías estar pasando un momento muy difícil. Esto excede lo que esta app puede ayudar — por favor contactá a una línea de ayuda o a alguien de confianza ahora mismo.",
  },
  {
    code: "eating_disorder_risk",
    severity: "block",
    patterns: [
      /(me purgu|purga|vomito? después de comer|vomitar? la comida)/i,
      /(no (he comido|como) (nada )?(en|hace) \d+ días)/i,
      /binge eating|atracón(es)?/i,
      /\bpurging\b/i,
    ],
    message:
      "Detectamos una posible señal de riesgo relacionada con la alimentación. No vamos a generar recomendaciones de dieta o déficit calórico en este contexto — te recomendamos hablar con un profesional de salud.",
  },
  {
    code: "pregnancy_breastfeeding",
    severity: "warn",
    patterns: [/embarazad|estoy embarazo|lactancia|amamant|breastfeeding|\bpregnant\b/i],
    message:
      "Mencionaste embarazo o lactancia. Los objetivos de entrenamiento y nutrición cambian en este contexto — te recomendamos seguir las indicaciones de tu obstetra/nutricionista antes de aplicar un plan generado por IA.",
  },
  {
    code: "injury_disclosed",
    severity: "warn",
    patterns: [/me lesion|tengo una lesión|injury|me rompí|esguince|desgarro/i],
    message:
      "Mencionaste una lesión. Tratala de forma conservadora: consultá a un profesional antes de continuar con el ejercicio afectado.",
  },
];

export function screenFreeText(text: string | null | undefined, context: string): SafetyFlag[] {
  if (!text) return [];
  const flags: SafetyFlag[] = [];
  for (const rule of TEXT_RULES) {
    if (rule.patterns.some((p) => p.test(text))) {
      flags.push({ code: rule.code, severity: rule.severity, message: rule.message });
    }
  }
  return flags;
}

export function evaluateFreeText(text: string | null | undefined, context: string): SafetyOutcome {
  return outcome(screenFreeText(text, context));
}

// ---------------------------------------------------------------------------
// Nutrición: pisos de calorías seguros. No reemplaza el cálculo (Mifflin-St
// Jeor ya vive en generate-ai-plan.ts), solo evita que el resultado final
// caiga en un déficit peligroso sin supervisión.
// ---------------------------------------------------------------------------

const MIN_SAFE_CALORIES_FEMALE_PATTERN = 1200;
const MIN_SAFE_CALORIES_MALE_PATTERN = 1500;

export interface NutritionTargetsInput {
  dailyCalories: number;
  biologicalSex: "male" | "female" | "unspecified";
}

export interface NutritionTargetsResult extends SafetyOutcome {
  /** Calorías ya ajustadas al piso seguro si hizo falta clamp. */
  dailyCalories: number;
}

export function evaluateNutritionTargets(input: NutritionTargetsInput): NutritionTargetsResult {
  const floor = input.biologicalSex === "male" ? MIN_SAFE_CALORIES_MALE_PATTERN : MIN_SAFE_CALORIES_FEMALE_PATTERN;
  if (input.dailyCalories >= floor) {
    return { allowed: true, flags: [], dailyCalories: input.dailyCalories };
  }
  const flag: SafetyFlag = {
    code: "extreme_calorie_deficit",
    severity: "warn",
    message: `El cálculo dio ${Math.round(input.dailyCalories)} kcal/día, por debajo del piso seguro recomendado (${floor} kcal). Ajustamos el objetivo a ${floor} kcal — un déficit mayor requiere supervisión de un profesional.`,
  };
  return { allowed: true, flags: [flag], dailyCalories: floor };
}

// ---------------------------------------------------------------------------
// Ayuno: cap duro para duraciones que requieren supervisión médica. El
// tracking en sí ya evita gamificación (manage-fasting.ts, SPEC §35.3);
// esto es el límite de seguridad sobre la duración objetivo.
// ---------------------------------------------------------------------------

const FASTING_WARN_HOURS = 24;
const FASTING_BLOCK_HOURS = 72;

export function evaluateFastingRequest(targetHours: number | undefined): SafetyOutcome {
  if (targetHours == null) return outcome([]);
  if (targetHours > FASTING_BLOCK_HOURS) {
    return outcome([
      {
        code: "extended_fast_unsupervised",
        severity: "block",
        message: `Un ayuno de ${targetHours}h supera lo que esta app puede recomendar sin supervisión médica (límite: ${FASTING_BLOCK_HOURS}h). Consultá a un profesional de salud antes de intentar un ayuno tan largo.`,
      },
    ]);
  }
  if (targetHours > FASTING_WARN_HOURS) {
    return outcome([
      {
        code: "long_fast",
        severity: "warn",
        message: `Un ayuno de ${targetHours}h es más largo que un ayuno intermitente estándar. Prestá atención a mareos, hidratación y electrolitos, y consultá a un profesional si es la primera vez que lo intentás.`,
      },
    ]);
  }
  return outcome([]);
}

import { NextResponse } from "next/server";
import { analyzeProgress } from "@fitness-app/api";
import type { ProgressRange } from "@fitness-app/shared";
import { PROGRESS_RANGES } from "@fitness-app/shared";
import { createClient } from "@/lib/supabase/server";
import { getAnthropicClient, isAnthropicConfigured, REASONING_MODEL } from "@/lib/anthropic";
import { checkRateLimit } from "@/lib/rate-limit";

interface AskBody {
  question: string;
  range?: ProgressRange;
}

const SYSTEM_PROMPT = `Sos un coach de fitness/nutrición que responde preguntas sobre el progreso de un usuario.
Respondé ÚNICAMENTE en base a los datos JSON que se te dan a continuación — nunca inventes números que no estén ahí.
Si los datos son insuficientes para responder algo con confianza, decilo explícitamente (ej. "todavía no tenés
suficientes registros de peso en este período para ver una tendencia clara").
No diagnostiques condiciones médicas ni dés indicaciones que reemplacen a un profesional de salud.
Respondé en español, en 2-4 oraciones, tono directo y alentador, sin markdown.`;

/**
 * Respalda el criterio de éxito del MVP "preguntarle a la IA por su
 * progreso y obtener respuesta basada en datos reales" (SPEC §27.11) en
 * la superficie web. analyzeProgress (packages/api) ya arma los datos
 * grounded — acá solo se los pasamos al modelo para que los explique en
 * lenguaje natural, nunca para que invente sus propios números.
 */
export async function POST(req: Request) {
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user) return NextResponse.json({ error: "No autenticado" }, { status: 401 });

  const rateLimit = checkRateLimit(`progress-ask:${user.id}`, 15, 10 * 60 * 1000);
  if (!rateLimit.allowed) {
    return NextResponse.json(
      { error: "Demasiadas preguntas en poco tiempo. Esperá unos minutos e intentá de nuevo." },
      { status: 429, headers: { "Retry-After": String(rateLimit.retryAfterSeconds ?? 60) } },
    );
  }

  if (!isAnthropicConfigured()) {
    return NextResponse.json(
      { error: "Preguntarle a la IA todavía no está configurado (falta ANTHROPIC_API_KEY)." },
      { status: 501 },
    );
  }

  let body: AskBody;
  try {
    body = (await req.json()) as AskBody;
  } catch {
    return NextResponse.json({ error: "Body inválido" }, { status: 400 });
  }
  const question = body.question?.trim();
  if (!question) return NextResponse.json({ error: "Falta la pregunta" }, { status: 400 });
  if (question.length > 500) return NextResponse.json({ error: "Pregunta demasiado larga (máx. 500 caracteres)." }, { status: 400 });

  const range: ProgressRange = body.range && PROGRESS_RANGES.includes(body.range) ? body.range : "90d";

  const grounded = await analyzeProgress(supabase, user.id, range, question);

  const client = getAnthropicClient();
  let response;
  try {
    response = await client.messages.create({
      model: REASONING_MODEL,
      max_tokens: 512,
      system: SYSTEM_PROMPT,
      messages: [
        {
          role: "user",
          content: `Datos de progreso (período ${range}):\n${JSON.stringify(grounded)}\n\nPregunta del usuario: ${question}`,
        },
      ],
    });
  } catch (err) {
    console.error("Error llamando a Claude para analyze_progress", err);
    return NextResponse.json({ error: "No se pudo generar la respuesta. Probá de nuevo." }, { status: 502 });
  }

  const textBlock = response.content.find((b) => b.type === "text");
  const answer = textBlock && "text" in textBlock ? textBlock.text : "No se pudo generar una respuesta.";

  return NextResponse.json({ answer, dataCompleteness: grounded.dataCompleteness });
}

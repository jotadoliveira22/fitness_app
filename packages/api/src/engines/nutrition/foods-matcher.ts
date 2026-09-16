import type { FoodRecord } from "../../data-access/foods.repository.js";

export interface MealCandidateItem {
  foodDescription: string;
  foodId?: string;
  quantity: number;
  unit: string;
  calories: number;
  proteinG: number;
  carbsG: number;
  fatG: number;
  confidence: number;
  matched: boolean;
}

const GRAMS_PER_UNIT: Record<string, number> = {
  g: 1,
  gr: 1,
  gramos: 1,
  kg: 1000,
  ml: 1,
  taza: 240,
  tazas: 240,
  cucharada: 15,
  cucharadas: 15,
};

const QUANTITY_PATTERN =
  /^(\d+(?:[.,]\d+)?)\s*(g|gr|gramos|kg|ml|tazas?|cucharadas?|unidad(?:es)?)?\s*(?:de\s+)?(.+)$/i;

function splitDescriptionIntoTokens(description: string): string[] {
  return description
    .split(/,| y | con |\+/i)
    .map((token) => token.trim())
    .filter((token) => token.length > 0);
}

function normalize(text: string): string {
  return text.toLowerCase().trim();
}

function findBestFood(foods: FoodRecord[], name: string): { food: FoodRecord; confidence: number } | null {
  const normalizedName = normalize(name);
  let best: { food: FoodRecord; confidence: number } | null = null;

  for (const food of foods) {
    if (normalize(food.name) === normalizedName) return { food, confidence: 0.9 };
    if (food.aliases.some((alias) => normalize(alias) === normalizedName)) return { food, confidence: 0.9 };

    const isSubstring =
      normalizedName.includes(normalize(food.name)) ||
      normalize(food.name).includes(normalizedName) ||
      food.aliases.some(
        (alias) => normalizedName.includes(normalize(alias)) || normalize(alias).includes(normalizedName),
      );
    if (isSubstring && (!best || best.confidence < 0.6)) {
      best = { food, confidence: 0.6 };
    }
  }

  return best;
}

function parseToken(token: string): { quantity: number; unit: string | null; name: string } {
  const match = token.match(QUANTITY_PATTERN);
  if (match) {
    const rawQuantity = match[1]!.replace(",", ".");
    return { quantity: parseFloat(rawQuantity), unit: match[2] ? match[2].toLowerCase() : null, name: match[3]!.trim() };
  }
  return { quantity: 1, unit: null, name: token.trim() };
}

/**
 * Empareja contra el catálogo de alimentos en lugar de inventar valores
 * nutricionales (mismo criterio que el catálogo de ejercicios, SPEC §34.2).
 * La interpretación de lenguaje natural en sí (dividir la frase en items) es
 * una heurística simple y determinística, no una llamada a un modelo — el
 * cliente MCP (que sí tiene capacidad de lenguaje) puede mandar una
 * descripción ya más limpia si quiere mejores resultados.
 */
export function matchFoodsFromDescription(foods: FoodRecord[], description: string): MealCandidateItem[] {
  const tokens = splitDescriptionIntoTokens(description);

  return tokens.map((token) => {
    const { quantity, unit, name } = parseToken(token);
    const match = findBestFood(foods, name);

    if (!match) {
      return {
        foodDescription: name,
        quantity,
        unit: unit ?? "porción",
        calories: 0,
        proteinG: 0,
        carbsG: 0,
        fatG: 0,
        confidence: 0,
        matched: false,
      };
    }

    const { food, confidence } = match;
    const gramsPerUnit = unit ? (GRAMS_PER_UNIT[unit] ?? food.defaultServingGrams ?? 100) : food.defaultServingGrams ?? 100;
    const totalGrams = quantity * gramsPerUnit;
    const scale = totalGrams / 100;

    return {
      foodDescription: food.name,
      foodId: food.id,
      quantity,
      unit: unit ?? food.defaultServingLabel ?? "porción",
      calories: Math.round(food.caloriesPer100g * scale),
      proteinG: Math.round(food.proteinGPer100g * scale * 10) / 10,
      carbsG: Math.round(food.carbsGPer100g * scale * 10) / 10,
      fatG: Math.round(food.fatGPer100g * scale * 10) / 10,
      confidence,
      matched: true,
    };
  });
}

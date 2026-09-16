import type { SupabaseClient } from "@supabase/supabase-js";
import type { ProvenanceSource } from "@fitness-app/shared";
import { DataAccessError } from "./errors.js";

export interface NutritionItemInput {
  foodDescription: string;
  quantity?: number | undefined;
  unit?: string | undefined;
  calories?: number | undefined;
  proteinG?: number | undefined;
  carbsG?: number | undefined;
  fatG?: number | undefined;
  source: ProvenanceSource;
  confidence?: number | undefined;
  allowsSubstitution?: boolean | undefined;
  notes?: string | undefined;
}

export interface NutritionMealInput {
  name: string;
  timeOfDay?: string;
  items: NutritionItemInput[];
}

export interface NutritionItemRecord extends NutritionItemInput {
  id: string;
}

export interface NutritionMealRecord {
  id: string;
  name: string;
  timeOfDay: string | null;
  items: NutritionItemRecord[];
}

export interface NutritionVersionContent {
  versionId: string;
  versionNumber: number;
  meals: NutritionMealRecord[];
}

export async function insertVersion(
  client: SupabaseClient,
  planId: string,
  versionNumber: number,
  notes?: string,
): Promise<{ id: string }> {
  const { data, error } = await client
    .from("nutrition_plan_versions")
    .insert({ plan_id: planId, version_number: versionNumber, notes: notes ?? null })
    .select("id")
    .single<{ id: string }>();

  if (error) throw new DataAccessError("No se pudo crear la versión del plan", error);
  return data;
}

export async function insertMealsWithItems(
  client: SupabaseClient,
  versionId: string,
  meals: NutritionMealInput[],
): Promise<NutritionMealRecord[]> {
  const results: NutritionMealRecord[] = [];

  for (let index = 0; index < meals.length; index++) {
    const meal = meals[index]!;
    const { data: mealRow, error: mealError } = await client
      .from("nutrition_plan_meals")
      .insert({
        version_id: versionId,
        name: meal.name,
        time_of_day: meal.timeOfDay ?? null,
        order_index: index,
      })
      .select("id, name, time_of_day")
      .single<{ id: string; name: string; time_of_day: string | null }>();

    if (mealError) throw new DataAccessError("No se pudo guardar la comida del plan", mealError);

    const itemRows = meal.items.map((item) => ({
      meal_id: mealRow.id,
      food_description: item.foodDescription,
      quantity: item.quantity ?? null,
      unit: item.unit ?? null,
      calories: item.calories ?? null,
      protein_g: item.proteinG ?? null,
      carbs_g: item.carbsG ?? null,
      fat_g: item.fatG ?? null,
      source: item.source,
      confidence: item.confidence ?? null,
      allows_substitution: item.allowsSubstitution ?? false,
      notes: item.notes ?? null,
    }));

    const { data: insertedItems, error: itemsError } = await client
      .from("nutrition_plan_items")
      .insert(itemRows)
      .select(
        "id, food_description, quantity, unit, calories, protein_g, carbs_g, fat_g, source, confidence, allows_substitution, notes",
      );

    if (itemsError) throw new DataAccessError("No se pudieron guardar los items del plan", itemsError);

    results.push({
      id: mealRow.id,
      name: mealRow.name,
      timeOfDay: mealRow.time_of_day,
      items: (insertedItems as Array<Record<string, unknown>>).map((row) => ({
        id: row["id"] as string,
        foodDescription: row["food_description"] as string,
        quantity: (row["quantity"] as number | null) ?? undefined,
        unit: (row["unit"] as string | null) ?? undefined,
        calories: (row["calories"] as number | null) ?? undefined,
        proteinG: (row["protein_g"] as number | null) ?? undefined,
        carbsG: (row["carbs_g"] as number | null) ?? undefined,
        fatG: (row["fat_g"] as number | null) ?? undefined,
        source: row["source"] as ProvenanceSource,
        confidence: (row["confidence"] as number | null) ?? undefined,
        allowsSubstitution: row["allows_substitution"] as boolean,
        notes: (row["notes"] as string | null) ?? undefined,
      })),
    });
  }

  return results;
}

export async function getLatestVersionContent(
  client: SupabaseClient,
  planId: string,
): Promise<NutritionVersionContent | null> {
  const { data: version, error: versionError } = await client
    .from("nutrition_plan_versions")
    .select("id, version_number")
    .eq("plan_id", planId)
    .order("version_number", { ascending: false })
    .limit(1)
    .maybeSingle<{ id: string; version_number: number }>();

  if (versionError) throw new DataAccessError("No se pudo obtener la versión del plan", versionError);
  if (!version) return null;

  const { data: meals, error: mealsError } = await client
    .from("nutrition_plan_meals")
    .select("id, name, time_of_day")
    .eq("version_id", version.id)
    .order("order_index", { ascending: true });

  if (mealsError) throw new DataAccessError("No se pudieron obtener las comidas del plan", mealsError);

  const mealRows = meals as Array<{ id: string; name: string; time_of_day: string | null }>;
  const mealRecords: NutritionMealRecord[] = [];

  for (const meal of mealRows) {
    const { data: items, error: itemsError } = await client
      .from("nutrition_plan_items")
      .select(
        "id, food_description, quantity, unit, calories, protein_g, carbs_g, fat_g, source, confidence, allows_substitution, notes",
      )
      .eq("meal_id", meal.id);

    if (itemsError) throw new DataAccessError("No se pudieron obtener los items de la comida", itemsError);

    mealRecords.push({
      id: meal.id,
      name: meal.name,
      timeOfDay: meal.time_of_day,
      items: (items as Array<Record<string, unknown>>).map((row) => ({
        id: row["id"] as string,
        foodDescription: row["food_description"] as string,
        quantity: (row["quantity"] as number | null) ?? undefined,
        unit: (row["unit"] as string | null) ?? undefined,
        calories: (row["calories"] as number | null) ?? undefined,
        proteinG: (row["protein_g"] as number | null) ?? undefined,
        carbsG: (row["carbs_g"] as number | null) ?? undefined,
        fatG: (row["fat_g"] as number | null) ?? undefined,
        source: row["source"] as ProvenanceSource,
        confidence: (row["confidence"] as number | null) ?? undefined,
        allowsSubstitution: row["allows_substitution"] as boolean,
        notes: (row["notes"] as string | null) ?? undefined,
      })),
    });
  }

  return { versionId: version.id, versionNumber: version.version_number, meals: mealRecords };
}

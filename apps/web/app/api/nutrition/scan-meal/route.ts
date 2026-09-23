import { NextResponse } from "next/server";
import Anthropic from "@anthropic-ai/sdk";
import type { MealCandidateItem } from "@fitness-app/api";
import { createClient } from "@/lib/supabase/server";
import { getAnthropicClient, isAnthropicConfigured, extractJson, VISION_MODEL } from "@/lib/anthropic";

const SYSTEM_PROMPT = `Sos un nutricionista que identifica alimentos en una foto de un plato de comida.
Respondé ÚNICAMENTE con un array JSON (sin texto antes ni después, sin \`\`\`), donde cada elemento tiene
exactamente estos campos:
{
  "foodDescription": string (nombre del alimento en español),
  "quantity": number (cantidad estimada),
  "unit": string (ej. "g", "taza", "unidad"),
  "calories": number (calorías totales de esa porción),
  "proteinG": number,
  "carbsG": number,
  "fatG": number,
  "confidence": number entre 0 y 1 (qué tan seguro estás de la estimación)
}
Si no identificás ningún alimento, respondé [].`;

interface ScanMealBody {
  imageBase64: string;
  mediaType: string;
}

export async function POST(req: Request) {
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user) return NextResponse.json({ error: "No autenticado" }, { status: 401 });

  if (!isAnthropicConfigured()) {
    return NextResponse.json(
      { error: "El reconocimiento de comida por foto todavía no está configurado (falta ANTHROPIC_API_KEY)." },
      { status: 501 },
    );
  }

  let body: ScanMealBody;
  try {
    body = (await req.json()) as ScanMealBody;
  } catch {
    return NextResponse.json({ error: "Body inválido" }, { status: 400 });
  }
  if (!body.imageBase64 || !body.mediaType) {
    return NextResponse.json({ error: "Falta la imagen" }, { status: 400 });
  }

  const client = getAnthropicClient();
  let response;
  try {
    response = await client.messages.create({
      model: VISION_MODEL,
      max_tokens: 2048,
      system: SYSTEM_PROMPT,
      messages: [
        {
          role: "user",
          content: [
            {
              type: "image",
              source: {
                type: "base64",
                media_type: body.mediaType as Anthropic.Base64ImageSource["media_type"],
                data: body.imageBase64,
              },
            },
            { type: "text", text: "Identificá los alimentos de esta foto y estimá sus valores nutricionales." },
          ],
        },
      ],
    });
  } catch (err) {
    console.error("Error llamando a Claude para escanear comida", err);
    return NextResponse.json({ error: "No se pudo analizar la foto. Probá de nuevo." }, { status: 502 });
  }

  const textBlock = response.content.find((b): b is Anthropic.TextBlock => b.type === "text");
  if (!textBlock) return NextResponse.json({ error: "Respuesta vacía del modelo" }, { status: 502 });

  let parsed: unknown;
  try {
    parsed = extractJson(textBlock.text);
  } catch {
    return NextResponse.json({ error: "No se pudo interpretar la respuesta del modelo" }, { status: 502 });
  }
  if (!Array.isArray(parsed)) {
    return NextResponse.json({ error: "Formato de respuesta inesperado" }, { status: 502 });
  }

  const candidates: MealCandidateItem[] = parsed.map((raw) => {
    const item = raw as Record<string, unknown>;
    return {
      foodDescription: String(item.foodDescription ?? "Alimento sin identificar"),
      quantity: Number(item.quantity) || 1,
      unit: String(item.unit ?? "porción"),
      calories: Number(item.calories) || 0,
      proteinG: Number(item.proteinG) || 0,
      carbsG: Number(item.carbsG) || 0,
      fatG: Number(item.fatG) || 0,
      confidence: typeof item.confidence === "number" ? item.confidence : 0.5,
      matched: true,
    };
  });

  return NextResponse.json({ candidates });
}

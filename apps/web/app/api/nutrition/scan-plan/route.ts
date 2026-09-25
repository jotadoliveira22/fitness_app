import { NextResponse } from "next/server";
import Anthropic from "@anthropic-ai/sdk";
import { createClient } from "@/lib/supabase/server";
import { getAnthropicClient, isAnthropicConfigured, extractJson, VISION_MODEL } from "@/lib/anthropic";

const SYSTEM_PROMPT = `Sos un asistente que transcribe planes de alimentación de nutricionistas (PDF o foto) a una
estructura de datos. Respondé ÚNICAMENTE con un objeto JSON (sin texto antes ni después, sin \`\`\`) con esta forma:
{
  "planName": string (nombre del plan, ej. "Plan Dra. Pérez - Definición"; si no hay nombre, inventá uno descriptivo corto),
  "meals": [
    {
      "name": string (ej. "Desayuno"),
      "timeOfDay": string opcional (ej. "08:00"),
      "items": [
        {
          "foodDescription": string,
          "quantity": number opcional,
          "unit": string opcional,
          "calories": number opcional,
          "proteinG": number opcional,
          "carbsG": number opcional,
          "fatG": number opcional
        }
      ]
    }
  ]
}
Transcribí fielmente lo que dice el documento; si algún valor nutricional no está explícito, omitilo (no lo inventes).`;

interface ScanPlanBody {
  fileBase64: string;
  mediaType: string;
  isPdf: boolean;
}

export async function POST(req: Request) {
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user) return NextResponse.json({ error: "No autenticado" }, { status: 401 });

  if (!isAnthropicConfigured()) {
    return NextResponse.json(
      { error: "La lectura automática de planes todavía no está configurada (falta ANTHROPIC_API_KEY)." },
      { status: 501 },
    );
  }

  let body: ScanPlanBody;
  try {
    body = (await req.json()) as ScanPlanBody;
  } catch {
    return NextResponse.json({ error: "Body inválido" }, { status: 400 });
  }
  if (!body.fileBase64 || !body.mediaType) {
    return NextResponse.json({ error: "Falta el archivo" }, { status: 400 });
  }
  // Tope de tamaño: sin esto, cualquier usuario autenticado podría mandar
  // payloads enormes y generar costo de API / presión de memoria sin límite.
  // ~14MB en base64 ≈ 10MB de archivo original, de sobra para una foto/PDF real.
  if (body.fileBase64.length > 14_000_000) {
    return NextResponse.json({ error: "El archivo es demasiado grande (máx. ~10MB)." }, { status: 413 });
  }

  const client = getAnthropicClient();
  const fileBlock: Anthropic.ContentBlockParam = body.isPdf
    ? { type: "document", source: { type: "base64", media_type: "application/pdf", data: body.fileBase64 } }
    : {
        type: "image",
        source: { type: "base64", media_type: body.mediaType as Anthropic.Base64ImageSource["media_type"], data: body.fileBase64 },
      };

  let response;
  try {
    response = await client.messages.create({
      model: VISION_MODEL,
      max_tokens: 4096,
      system: SYSTEM_PROMPT,
      messages: [
        {
          role: "user",
          content: [fileBlock, { type: "text", text: "Transcribí este plan de nutrición a la estructura pedida." }],
        },
      ],
    });
  } catch (err) {
    console.error("Error llamando a Claude para escanear plan", err);
    return NextResponse.json({ error: "No se pudo leer el archivo. Probá de nuevo." }, { status: 502 });
  }

  const textBlock = response.content.find((b): b is Anthropic.TextBlock => b.type === "text");
  if (!textBlock) return NextResponse.json({ error: "Respuesta vacía del modelo" }, { status: 502 });

  let parsed: unknown;
  try {
    parsed = extractJson(textBlock.text);
  } catch {
    return NextResponse.json({ error: "No se pudo interpretar la respuesta del modelo" }, { status: 502 });
  }

  return NextResponse.json(parsed);
}

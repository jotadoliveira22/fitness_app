import { UnauthorizedError } from "@fitness-app/api";
import { ZodError } from "zod";

export function respondJson(data: unknown) {
  return {
    content: [{ type: "text" as const, text: JSON.stringify(data) }],
  };
}

export function respondError(error: unknown) {
  let message = "Error inesperado";
  if (error instanceof ZodError) {
    message = `Datos inválidos: ${error.issues.map((issue) => issue.message).join("; ")}`;
  } else if (error instanceof UnauthorizedError) {
    message = error.message;
  } else if (error instanceof Error) {
    message = error.message;
  }

  return {
    content: [{ type: "text" as const, text: JSON.stringify({ error: message }) }],
    isError: true,
  };
}

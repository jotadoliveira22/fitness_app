export class DataAccessError extends Error {
  constructor(
    message: string,
    public readonly cause?: unknown,
  ) {
    super(message);
    this.name = "DataAccessError";
  }
}

export class NotFoundError extends DataAccessError {
  constructor(resource: string) {
    super(`${resource} no encontrado`);
    this.name = "NotFoundError";
  }
}

/**
 * Disparado por la Safety Layer cuando una señal de severidad "block"
 * impide continuar con la acción (SPEC §35.2). Los callers (MCP tools,
 * server actions de la web) deben mostrar `flags` al usuario en vez de un
 * error genérico.
 */
export class SafetyBlockedError extends DataAccessError {
  constructor(
    message: string,
    public readonly flags: Array<{ code: string; severity: string; message: string }>,
  ) {
    super(message);
    this.name = "SafetyBlockedError";
  }
}

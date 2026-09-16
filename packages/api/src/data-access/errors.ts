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

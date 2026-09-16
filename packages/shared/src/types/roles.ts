export const USER_ROLES = ["user", "professional", "admin"] as const;
export type UserRole = (typeof USER_ROLES)[number];

export const BIOLOGICAL_SEXES = ["female", "male", "unspecified"] as const;
export type BiologicalSex = (typeof BIOLOGICAL_SEXES)[number];

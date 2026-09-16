export const PHOTO_ANGLES = ["front", "side", "back"] as const;
export type PhotoAngle = (typeof PHOTO_ANGLES)[number];

export const FASTING_STATUSES = ["active", "completed", "cancelled"] as const;
export type FastingStatus = (typeof FASTING_STATUSES)[number];

export const PROGRESS_RANGES = ["30d", "90d", "6m", "1y"] as const;
export type ProgressRange = (typeof PROGRESS_RANGES)[number];

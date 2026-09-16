import { z } from "zod";

const scaleField = z.number().int().min(1).max(5).optional();

export const dailyCheckinSchema = z.object({
  date: z.string().date().optional(),
  energy: scaleField,
  sleepQuality: scaleField,
  stress: scaleField,
  soreness: scaleField,
  motivation: scaleField,
  notes: z.string().max(500).optional(),
});

export type DailyCheckinInput = z.infer<typeof dailyCheckinSchema>;

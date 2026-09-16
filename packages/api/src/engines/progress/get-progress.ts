import type { SupabaseClient } from "@supabase/supabase-js";
import type { ProgressRange } from "@fitness-app/shared";
import { listWeightLogsSince, type WeightLogRecord } from "../../data-access/weight-logs.repository.js";
import { listMeasurementsSince, type BodyMeasurementRecord } from "../../data-access/body-measurements.repository.js";
import {
  listPhotosSince,
  getSignedPhotoUrl,
  type ProgressPhotoRecord,
} from "../../data-access/progress-photos.repository.js";
import { listFastingSessionsSince } from "../../data-access/fasting-sessions.repository.js";
import { countSessionsSince, type TrainingAdherenceCounts } from "../../data-access/workout-sessions.repository.js";
import { listDistinctLogDatesSince } from "../../data-access/food-logs.repository.js";
import { getMaxWeightPerExercise } from "../../data-access/workout-sets.repository.js";
import { getExerciseById } from "../../data-access/exercises.repository.js";

function rangeToSinceDate(range: ProgressRange): Date {
  const now = new Date();
  const since = new Date(now);
  if (range === "30d") since.setDate(now.getDate() - 30);
  else if (range === "90d") since.setDate(now.getDate() - 90);
  else if (range === "6m") since.setMonth(now.getMonth() - 6);
  else since.setFullYear(now.getFullYear() - 1);
  return since;
}

function daysBetween(from: Date, to: Date): number {
  return Math.max(1, Math.round((to.getTime() - from.getTime()) / (24 * 60 * 60 * 1000)));
}

export interface ProgressPhotoWithUrl extends ProgressPhotoRecord {
  signedUrl: string;
}

export interface FastingSummary {
  totalFasts: number;
  averageDurationHours: number | null;
  longestDurationHours: number | null;
}

export interface PersonalRecordEntry {
  exerciseId: string;
  exerciseName: string;
  maxWeightKg: number;
  reps: number | null;
}

export interface ProgressResult {
  range: ProgressRange;
  weightTrend: WeightLogRecord[];
  measurements: BodyMeasurementRecord[];
  trainingAdherence: TrainingAdherenceCounts & { adherenceRate: number | null };
  nutritionAdherence: { daysWithLogs: number; totalDays: number; adherenceRate: number };
  fastingSummary: FastingSummary;
  progressPhotos: ProgressPhotoWithUrl[];
  personalRecords: PersonalRecordEntry[];
}

export async function getProgress(
  client: SupabaseClient,
  userId: string,
  range: ProgressRange,
): Promise<ProgressResult> {
  const sinceDate = rangeToSinceDate(range);
  const sinceIso = sinceDate.toISOString();
  const sinceDay = sinceIso.slice(0, 10);
  const totalDays = daysBetween(sinceDate, new Date());

  const [
    weightTrend,
    measurements,
    photos,
    fastingSessions,
    trainingCounts,
    logDates,
    maxWeights,
  ] = await Promise.all([
    listWeightLogsSince(client, userId, sinceDay),
    listMeasurementsSince(client, userId, sinceDay),
    listPhotosSince(client, userId, sinceDay),
    listFastingSessionsSince(client, userId, sinceIso),
    countSessionsSince(client, userId, sinceDay),
    listDistinctLogDatesSince(client, userId, sinceDay),
    getMaxWeightPerExercise(client, userId),
  ]);

  const progressPhotos: ProgressPhotoWithUrl[] = await Promise.all(
    photos.map(async (photo) => ({ ...photo, signedUrl: await getSignedPhotoUrl(client, photo.storagePath) })),
  );

  const completedFasts = fastingSessions.filter((session) => session.status === "completed" && session.endedAt);
  const durationsHours = completedFasts.map(
    (session) => (new Date(session.endedAt!).getTime() - new Date(session.startedAt).getTime()) / (60 * 60 * 1000),
  );
  const fastingSummary: FastingSummary = {
    totalFasts: fastingSessions.length,
    averageDurationHours:
      durationsHours.length > 0
        ? Math.round((durationsHours.reduce((a, b) => a + b, 0) / durationsHours.length) * 10) / 10
        : null,
    longestDurationHours: durationsHours.length > 0 ? Math.round(Math.max(...durationsHours) * 10) / 10 : null,
  };

  const personalRecords: PersonalRecordEntry[] = [];
  for (const entry of maxWeights) {
    const exercise = await getExerciseById(client, entry.exerciseId);
    if (!exercise) continue;
    personalRecords.push({
      exerciseId: entry.exerciseId,
      exerciseName: exercise.name,
      maxWeightKg: entry.maxWeightKg,
      reps: entry.reps,
    });
  }

  return {
    range,
    weightTrend,
    measurements,
    trainingAdherence: {
      ...trainingCounts,
      adherenceRate:
        trainingCounts.plannedSessions > 0
          ? Math.round((trainingCounts.completedSessions / trainingCounts.plannedSessions) * 100) / 100
          : null,
    },
    nutritionAdherence: {
      daysWithLogs: logDates.length,
      totalDays,
      adherenceRate: Math.round((logDates.length / totalDays) * 100) / 100,
    },
    fastingSummary,
    progressPhotos,
    personalRecords,
  };
}

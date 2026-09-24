"use client";

import { useState } from "react";
import { useRouter } from "next/navigation";
import { PHOTO_ANGLES, type PhotoAngle, type UploadProgressPhotoInput } from "@fitness-app/shared";
import { fileToBase64 } from "@/lib/file-to-base64";
import { CameraIcon } from "@/components/icons";

const ANGLE_LABELS: Record<PhotoAngle, string> = {
  front: "Frente",
  side: "Perfil",
  back: "Espalda",
};

interface ProgressPhotoUploaderProps {
  uploadProgressPhotoAction: (input: UploadProgressPhotoInput) => Promise<void>;
}

export function ProgressPhotoUploader({ uploadProgressPhotoAction }: ProgressPhotoUploaderProps) {
  const router = useRouter();
  const [angle, setAngle] = useState<PhotoAngle>("front");
  const [uploading, setUploading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  async function handleFile(file: File) {
    setUploading(true);
    setError(null);
    try {
      const base64 = await fileToBase64(file);
      await uploadProgressPhotoAction({ imageBase64: base64, mimeType: file.type, angle });
      router.refresh();
    } catch {
      setError("No se pudo subir la foto.");
    } finally {
      setUploading(false);
    }
  }

  return (
    <div className="mb-3">
      <div className="mb-2 flex gap-2">
        {PHOTO_ANGLES.map((a) => (
          <button
            key={a}
            type="button"
            onClick={() => setAngle(a)}
            className={`rounded-full px-3 py-1.5 text-xs font-semibold ${
              angle === a ? "bg-accent text-black" : "bg-surface-raised text-muted"
            }`}
          >
            {ANGLE_LABELS[a]}
          </button>
        ))}
      </div>
      {error && <p className="mb-2 text-xs text-red-400">{error}</p>}
      <label className="flex w-full cursor-pointer items-center justify-center gap-2 rounded-full bg-surface-raised py-3 text-xs font-semibold text-accent">
        <CameraIcon className="h-4 w-4" />
        {uploading ? "Subiendo..." : `+ Foto de ${ANGLE_LABELS[angle].toLowerCase()}`}
        <input
          type="file"
          accept="image/*"
          capture="environment"
          disabled={uploading}
          onChange={(e) => {
            const file = e.target.files?.[0];
            if (file) void handleFile(file);
            e.target.value = "";
          }}
          className="hidden"
        />
      </label>
    </div>
  );
}

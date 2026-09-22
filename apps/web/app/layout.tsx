import type { Metadata } from "next";
import "./globals.css";

export const metadata: Metadata = {
  title: "Fitness App",
  description: "Tu entrenador y nutricionista personal",
};

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html lang="es">
      <body>
        <div className="mx-auto min-h-screen max-w-md bg-bg">{children}</div>
      </body>
    </html>
  );
}

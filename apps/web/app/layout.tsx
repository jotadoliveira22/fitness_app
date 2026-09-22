import type { Metadata } from "next";
import { Inter, Montserrat } from "next/font/google";
import "./globals.css";

const inter = Inter({ subsets: ["latin"], variable: "--font-inter" });
const montserrat = Montserrat({ subsets: ["latin"], weight: ["600", "700", "800"], variable: "--font-montserrat" });

export const metadata: Metadata = {
  title: "Sumiva",
  description: "Todo suma a tu bienestar",
};

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html lang="es" className={`${inter.variable} ${montserrat.variable}`}>
      <body>
        <div className="mx-auto min-h-screen max-w-md bg-bg font-sans">{children}</div>
      </body>
    </html>
  );
}

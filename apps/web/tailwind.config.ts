import type { Config } from "tailwindcss";

const config: Config = {
  content: ["./app/**/*.{ts,tsx}", "./components/**/*.{ts,tsx}"],
  theme: {
    extend: {
      colors: {
        bg: "#0b0b0c",
        surface: "#161718",
        "surface-raised": "#1e1f20",
        border: "#2a2b2c",
        accent: "#c6ff00",
        "accent-secondary": "#7ed321",
        "accent-dim": "#8fae2a",
        muted: "#9a9c9e",
        warm: "#f7f7f5",
      },
      borderRadius: {
        "2xl": "1.25rem",
        "3xl": "1.75rem",
      },
      fontFamily: {
        sans: ["var(--font-inter)", "-apple-system", "BlinkMacSystemFont", "Segoe UI", "Roboto", "sans-serif"],
        display: ["var(--font-montserrat)", "var(--font-inter)", "sans-serif"],
      },
    },
  },
  plugins: [],
};

export default config;

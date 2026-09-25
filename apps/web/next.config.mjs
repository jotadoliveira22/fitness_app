// Headers de seguridad HTTP base. No incluye Content-Security-Policy todavía:
// una CSP estricta necesita probarse contra todos los scripts/estilos
// inline que Next.js inyecta en hidratación antes de activarla sin romper
// la app (ver SECURITY.md, sección "Próximos pasos").
const securityHeaders = [
  { key: "X-Frame-Options", value: "DENY" },
  { key: "X-Content-Type-Options", value: "nosniff" },
  { key: "Referrer-Policy", value: "strict-origin-when-cross-origin" },
  { key: "Permissions-Policy", value: "camera=(self), microphone=(), geolocation=(), interest-cohort=()" },
  { key: "Strict-Transport-Security", value: "max-age=63072000; includeSubDomains; preload" },
];

/** @type {import('next').NextConfig} */
const nextConfig = {
  reactStrictMode: true,
  transpilePackages: ["@fitness-app/api", "@fitness-app/shared"],
  async headers() {
    return [{ source: "/:path*", headers: securityHeaders }];
  },
  webpack(config) {
    // packages/api y packages/shared son TS fuente con imports NodeNext
    // (extensión .js apuntando a archivos .ts); webpack necesita el alias
    // explícito para resolverlos, a diferencia de tsc/tsx que lo hacen solos.
    config.resolve.extensionAlias = {
      ".js": [".ts", ".tsx", ".js"],
    };
    return config;
  },
};

export default nextConfig;

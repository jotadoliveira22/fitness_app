/** @type {import('next').NextConfig} */
const nextConfig = {
  reactStrictMode: true,
  transpilePackages: ["@fitness-app/api", "@fitness-app/shared"],
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

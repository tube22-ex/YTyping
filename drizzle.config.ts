/** biome-ignore-all lint/style/noProcessEnv: <srcファイル外のためprocess.envを許容> */
import { defineConfig } from "drizzle-kit";

if (!process.env.DATABASE_URL) {
  throw new Error("Missing DATABASE_URL");
}

// biome-ignore lint/style/noDefaultExport: <export defaultする必要がある>
export default defineConfig({
  schema: "./src/server/drizzle/schema.ts",
  out: "./drizzle",
  dialect: "postgresql",
  dbCredentials: { url: process.env.DATABASE_URL },
  strict: true,
});

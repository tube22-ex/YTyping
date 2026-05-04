import postgres from "postgres";

const OLD_URL = "postgresql://postgres:postgres@localhost:54322/postgres";
const NEW_URL =
  "postgresql://postgres.bggiuhbcmaqjstblsbyu:yGYg1ch9sfPl8n8i@aws-1-ap-northeast-1.pooler.supabase.com:6543/postgres?sslmode=require";

async function migrate() {
  const oldSql = postgres(OLD_URL);
  const newSql = postgres(NEW_URL);

  console.log("🚀 Starting migration...");

  try {
    // 1. Users
    console.log("👥 Migrating Users...");
    const users = await oldSql`SELECT * FROM users`;
    if (users.length > 0) {
      await newSql`INSERT INTO users ${newSql(users)} ON CONFLICT DO NOTHING`;
      console.log(`✅ Migrated ${users.length} users.`);
    }

    // 2. Maps
    console.log("🗺️ Migrating Maps...");
    const maps = await oldSql`SELECT * FROM maps`;
    if (maps.length > 0) {
      await newSql`INSERT INTO maps ${newSql(maps)} ON CONFLICT DO NOTHING`;
      console.log(`✅ Migrated ${maps.length} maps.`);
    }

    // 3. Map Difficulties
    console.log("📊 Migrating Map Difficulties...");
    const diffs = await oldSql`SELECT * FROM map_difficulties`;
    if (diffs.length > 0) {
      await newSql`INSERT INTO map_difficulties ${newSql(diffs)} ON CONFLICT DO NOTHING`;
      console.log(`✅ Migrated ${diffs.length} difficulties.`);
    }

    console.log("🎉 ALL DATA MIGRATED SUCCESSFULLY!");
  } catch (error) {
    console.error("❌ Migration failed:", error);
  } finally {
    await oldSql.end();
    await newSql.end();
  }
}

migrate();

const Database = require("better-sqlite3");
const nodeCrypto = require("crypto");

const DB = "D:\\dahab-—-travel-platform\\Travel.eg\\data\\dahab.sqlite";
const email = "admin.demo@dahab.travel";
const password = "AdminDemo2026!Secure";

const db = Database(DB);
const exists = db.prepare("select 1 from users where email = ?").get(email);
if (exists) {
  console.log("EXISTS already:", email);
  process.exit(0);
}
const salt = nodeCrypto.randomBytes(16).toString("hex");
const hash = nodeCrypto.scryptSync(password, salt, 64).toString("hex");
const now = new Date().toISOString();
const id = "USR-ADMIN-DEMO-01";
const seq = (db.prepare("select max(seq) as m from users").get().m || 0) + 1;
const data = {
  id, email, name: "Demo Admin", phone: "+20 100 000 0004",
  passwordHash: hash, passwordSalt: salt, passwordAlgorithm: "scrypt",
  role: "Admin", createdAt: now, updatedAt: now,
};
db.prepare(
  "insert into users (id, seq, email, firebase_uid, role, supplier_id, phone, created_at, updated_at, data) values (?,?,?,?,?,?,?,?,?,?)"
).run(id, seq, email, null, "Admin", null, "+20 100 000 0004", now, now, JSON.stringify(data));
console.log("INSERTED:", db.prepare("select id,email,role from users where id=?").get(id));
db.close();

// backend/src/config/db.ts
import { Pool } from 'pg';
import dotenv from 'dotenv';

dotenv.config();

const pool = new Pool({
  connectionString: process.env.DATABASE_URL,
});

interface PoolErrorEventHandler {
    (err: Error): void;
}

pool.on('error', ((err: Error) => {
    console.error('Unexpected Postgres error', err);
    process.exit(-1);
}) as PoolErrorEventHandler);

export default pool;

import { Pool } from 'pg';

export const pool = new Pool({
  database: process.env.POSTGRES_DB,
  host: 'localhost',
  user: process.env.POSTGRES_USER,
  password: process.env.POSTGRES_PASSWORD,
  port: 5432,
});

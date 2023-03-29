import { Pool } from 'pg'
import fs from "fs"

// set env to be testing db 
require("dotenv").config()
process.env.POSTGRES_DB = 'test'

// pg database connect
export const pool = new Pool({
  database: process.env.POSTGRES_DB,
  host: 'localhost',
  user: process.env.POSTGRES_USER,
  password: process.env.POSTGRES_PASSWORD,
  port: 5432,
})

// split sql file and insert statements to db
export const insert = async (sql_file: string) => {
  const statements = fs.readFileSync(sql_file).toString().split("\r\n");
  for (const statement of statements) {
    const { rows } = await pool.query(statement)
  }
}

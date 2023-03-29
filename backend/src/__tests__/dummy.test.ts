import supertest from "supertest";
import * as db from "./db"
import app from "../app";

let request: any;
let server: any;

beforeAll(async () => {
  server = app.listen(process.env.PORT || 3000);
  request = supertest(server);
  await db.insert("sql/test/02.schema.sql");
  await db.insert("sql/test/03.data.sql");
})

afterAll((done) => {
  server.close(done)
  db.pool.end()
})

describe("Connect to SwaggerUI docs", () => {
  test("Get Docs", async () => {
    await request.get('/docs/')
      .expect(200)
      .then((res: any) => {
        expect(res.body).toBeDefined()
      })
  });
}) 

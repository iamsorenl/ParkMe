import supertest from "supertest";
import * as db from "../db"
import app from "../../app";

let request: any;
let server: any;

import * as login from "../loginHelper"

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

describe("Test getting posted spots that are owned", () => {
  test("Get User", async () => {
    const token = await login.asFrodoBaggins(request);
    await request.get('/spot/owned')
      .set("Authorization", `Bearer ${token}`)
      .expect(200)
      .then((res: any) => {
        expect(res.body).toBeDefined()
        expect(res.body[0]).toBeDefined()
        expect(res.body[0].uid).toBe(login.frodoBaggins.id)
      })
  });
})

import supertest from "supertest";
import * as db from "../db"
import app from "../../app";

let request: any;
let server: any;

import * as login from "../loginHelper"
import { Spot } from "src/types/spot";

beforeAll(async () => {
  server = app.listen(process.env.PORT || 3000);
  request = supertest(server);
  await db.insert("sql/test/02.schema.sql");
  await db.insert("sql/test/03.data.sql");
})
afterAll((done) => {
  db.pool.end()
  server.close(done)
})


describe("Get Available Spots", () => {
  const now = new Date().toISOString()
  console.log(now);
  const spot_id = "d15b4670-3152-42f6-b67f-5f761b77146b"
  test("Get available spot no params", async () => {
    const token = await login.asFrodoBaggins(request);
    await request.get('/spot/available')
      .set("Authorization", `Bearer ${token}`)
      .expect(200)
      .then((res: any) => {
        expect(res.body).toBeDefined()
      })
  });

  test("Get available spot time params", async () => {
    const token = await login.asFrodoBaggins(request);
    await request.get(`/spot/available?start=${now}&end=${now}`)
      .set("Authorization", `Bearer ${token}`)
      .expect(200)
      .then((res: { body: Spot[]}) => {
        expect(res.body).toBeDefined()
        expect(res.body.length).toBeGreaterThan(0);
      })
  });

  test("Get available spot time params and spot id", async () => {
    const token = await login.asFrodoBaggins(request);
    await request.get(`/spot/available?start=${now}&end=${now}&id=${spot_id}`)
      .set("Authorization", `Bearer ${token}`)
      .expect(200)
      .then((res: { body: Spot[]}) => {
        expect(res.body).toBeDefined()
        expect(res.body.length).toBe(1);
        expect(res.body[0].id).toBe(spot_id)
      })
  });

})

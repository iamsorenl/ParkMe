import supertest from "supertest";
import * as db from "../db"
import app from "../../app";

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

describe("Get valid user by ID", () => {
  test("Get User", async () => {
    await request.get('/user/00000000-0000-0000-0000-000000000001')
      .expect(401)
    // .then((res: any) => {
    //     expect(res.body).toBeDefined()
    //     expect(res.body.user).toBeDefined()
    //     expect(res.body.user.name).toBe('Frodo Baggins')
    //     expect(res.body.user.email).toBeDefined()
    //     expect(res.body.user.scopes).toBeDefined()
    //     expect(res.body.user.password).not.toBeDefined()
    // })
  });
})

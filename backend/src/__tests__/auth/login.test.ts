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

test('POST Valid Login', async () => {
  await request.post('/login')
    .send({ email: "frodo@theshire.com", password: "adventure" })
    .expect(200)
    .then((data: any) => {
      expect(data.body).toBeDefined();
      expect(data.body.name).toBe("Frodo Baggins");
      expect(data.body.token).toBeDefined();
      expect(data.body.id).toBeDefined();
    })
})

test('POST Invalid Credentials', async () => {
  await request.post('/login')
    .send({
      email: 'nobody@gmail.com',
      password: 'let me in!'
    })
    .expect(401);
})

test('POST Invalid Email Format', async () => {
  await request.post('/login')
    .send({
      email: 'nobody',
      password: 'let me in!'
    })
    .expect(400);
})

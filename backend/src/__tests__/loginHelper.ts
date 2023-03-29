import supertest from 'supertest';
import { UserCredentials } from 'src/types/auth';

export const frodoBaggins = {
  email: 'frodo@theshire.com',
  password: 'adventure',
  id: '00000000-0000-0000-0000-000000000001'
};

export const bilboBaggins = {
  email: 'bilbo@theshire.com',
  password: 'bilbo',
};

async function login(request: supertest.SuperTest<supertest.Test>, member: UserCredentials): Promise<string | undefined> {
  let accessToken;
  await request.post('/login')
    .send({
      email: member.email,
      password: member.password
    })
    .expect(200)
    .then((res) => {
      accessToken = res.body.token;
    });
  return accessToken;
}

export async function asFrodoBaggins(request: supertest.SuperTest<supertest.Test>): Promise<string | undefined> {
  return login(request, frodoBaggins);
}

export async function asBilboBaggins(request: supertest.SuperTest<supertest.Test>): Promise<string | undefined> {
  return login(request, bilboBaggins);
}

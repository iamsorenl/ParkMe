import * as express from "express";
import * as jwt from "jsonwebtoken";

import { UserCredentials, UserToken } from "../types/auth"
import { pool } from "../db"
import { UserPrivate } from "../types/user";

const secretKey = process.env.JWT_ACCESS_TOKEN || "";

export class AuthService {
  public async login(
    creds: UserCredentials
  ): Promise<UserToken | undefined> {
    const SELECT = `
    SELECT data || jsonb_build_object('id', id) as user from account
    where data->>'email'=$1 and data->>'password'=crypt($2, data->>'password')`;
    const QUERY = {
      text: SELECT,
      values: [
        `${creds.email}`,
        `${creds.password}`,
      ]
    };
    const { rows } = await pool.query(QUERY);
    const user = rows.length == 1 ? rows[0].user : undefined;

    if (user) {
      const JWT = jwt.sign(
        {
          email: user.email,
          name: user.name,
          id: user.id,
          scopes: user.scopes
        },
        secretKey,
        { algorithm: 'HS256' }
      );
      return { name: user.name, id: user.id, token: JWT };
    }
    return undefined
  }

  public async check(
    request: express.Request,
    scopes?: string[],
  ): Promise<string | UserPrivate> {
    return new Promise((resolve, reject) => {
      if (!request.headers.authorization) {
        reject(new Error("Unauthorized"))
      } else {
        const token = request.headers.authorization.split(' ')[1];
        if (!token) {
          reject()
        }
        jwt.verify(token, secretKey, function (err, decoded) {
          const user = decoded as UserPrivate
          if (err) {
            reject(err);
          } else if (scopes) {
            for (const scope of scopes)
              if (!user.scopes.includes(scope)) {
                reject(new Error("Unauthorized"));
              }
          }
          resolve({ email: user.email, name: user.name, id: user.id, scopes: user.scopes });
        });
      }
    });
  }
}

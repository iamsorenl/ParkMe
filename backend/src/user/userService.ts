import { UserPublic, UserPrivate } from '../types/user'
import { pool } from '../db';
import { UUID } from '../types/custom';
import { CreateAccountArgs } from './types';

export class UserService {
  public async select(id: UUID): Promise<UserPublic | undefined> {
    // Selects the user from the 'account' table based on the provided 'id', removes the 'password' field and adds the 'id' field to the JSON object
    const SELECT = `SELECT data - 'password' || jsonb_build_object('id', id) AS user FROM account where id = $1`
    const QUERY = {
      text: SELECT,
      values: [id]
    };
    const { rows } = await pool.query(QUERY);
    return rows.length == 1 ? rows[0] : undefined
  }

  public async add(user: any): Promise<UserPublic> {
    // Adds a new user to the 'account' table with the provided data and a hashed password using the 'bf' algorithm
    user.scopes = ['user'];
    const { password, ...rest } = user;

    const INSERT = `
        INSERT INTO account (data) VALUES ($1 || jsonb_build_object('password', crypt($2::text, gen_salt('bf')))) 
        RETURNING data || jsonb_build_object('id', id) AS data`;

    const QUERY = {
      text: INSERT,
      values: [
        `${JSON.stringify(rest)}`,
        `${password}`,
      ]
    };
    const { rows } = await pool.query(QUERY);
    return rows[0].data;
  }

  public async edit(id: UUID, payload: any): Promise<UserPublic | undefined> {
    // Edits an existing user in the 'account' table with the provided 'id' and 'payload' data, removes the 'password' field and adds the 'id' field to the JSON object
    const UPDATE = `
      UPDATE account SET data = (data || $1)
      WHERE id = $2
      RETURNING (data - 'password' || jsonb_build_object('id', id))
      AS user`;
    const QUERY = {
      text: UPDATE,
      values: [ `${JSON.stringify(payload)}`, `${id}`]
    };
    const { rows } = await pool.query(QUERY);
    return rows.length > 0 ? rows[0].user : undefined;
  }  
}

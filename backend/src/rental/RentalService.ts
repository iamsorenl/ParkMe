import { InputPostRental, Rent, RentedSpot } from "../types/rental";
import { pool } from "../db";
import { UUID } from "../types/custom";

export class RentalService {
  public async getSpotsByRenterID(renterId: UUID): Promise<RentedSpot[]> {
    const select = `
    SELECT (s.data || jsonb_build_object('id', s.id) || r.data) as rentals
    FROM spot s
    INNER JOIN rental r
    ON r.sid=s.id WHERE r.uid=$1
    `;

    const query = {
      text: select,
      values: [`${renterId}`],
    }
    try {
      const {rows} = await pool.query(query);
      return rows.map(r => r.rentals);
    } catch(e) {
      console.log(e);
      throw new Error('unexpected error');
    }
  }


  public async getByRenterID(renterId: UUID): Promise<Rent[]> {
    const SELECT = `
          SELECT
            rental.id as id,
            rental.sid as sid,
            rental.uid as uid,
            (rental.data->>'amount')::integer as amount,
            rental.data->>'start' as start,
            rental.data->>'end' as end
          FROM rental
          WHERE rental.uid = $1`;

    const QUERY = {
      text: SELECT,
      values: [renterId]
    };

    const { rows } = await pool.query(QUERY);

    return rows;
  }

  public async getByRentalID(rentalId: UUID): Promise<Rent | undefined> {
    const QUERY = {
      text: `
            SELECT rental.id as id, rental.sid as sid, rental.uid as uid, (rental.data->>'amount') as amount, rental.data->>'end' as end, rental.data->>'start' as start
            FROM rental
            WHERE rental.id = $1
          `,
      values: [rentalId],
    };
    const { rows } = await pool.query(QUERY);
    if (rows.length > 0) {
      return rows[0];
    }
    return undefined;
  }

  public async getBySpotID(spotId: UUID): Promise<Rent[]> {
    const QUERY = {
      text: `
            SELECT rental.id as id, rental.sid as sid, rental.uid as uid, (rental.data->>'amount') as amount, rental.data->>'end' as end, rental.data->>'start' as start
            FROM rental
            WHERE rental.sid = $1
          `,
      values: [spotId],
    };
    const { rows } = await pool.query(QUERY);
    return rows;
  }


  public async createRental(rentalInput: InputPostRental, uid: UUID): Promise<Rent> {
    const INSERT = `
          INSERT INTO rental (sid, uid, data) VALUES ($1, $2, $3)
          RETURNING (jsonb_build_object('id', id, 'sid', sid, 'uid', uid) || data) as rental`;

    const QUERY = {
      text: INSERT,
      values: [
        rentalInput.sid,
        uid,
        JSON.stringify({
          start: rentalInput.start,
          end: rentalInput.end,
          amount: rentalInput.amount,
        }),
      ],
    };
    try {
      const { rows } = await pool.query(QUERY);
      console.log(rows);
      return rows[0].rental;
    } catch (e) {
      console.log(e);
      throw e;
    }
  }
}

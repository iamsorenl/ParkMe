import { Spot, InputTypeSpot } from "../types/spot";
import { pool } from '../db';
import { UUID } from 'src/types/custom';

export class SpotService {
  /**
   * Gets a spot by its license plate.
   * @param id The license plate of the spot to retrieve.
   * @returns The matching spot, if found.
   */
  public async getByID(id: UUID): Promise<Spot | undefined> {
    // Define the SELECT statement to retrieve the data for the matching spot
    const SELECT = `SELECT data || jsonb_build_object('id', id) as spot FROM spot WHERE id = $1`;

    // Define the query object that will be passed to the database
    const QUERY = {
      text: SELECT,
      values: [id] // passing in the licensePlate parameter
    };

    // Execute the query and retrieve the matching spot
    const { rows } = await pool.query(QUERY);

    // Return the first (and only) row as a Spot object
    return rows.length == 1 ? rows[0].spot : undefined;
  }

  public async getAllAvailableSpots(start: string, end: string, id: string | undefined) {
    const values = [start, end, `${id}`]
    let SELECT = `select jsonb_build_object('id', id) || data as spot from spot
    WHERE(data ->'time'->>'start'):: timestamp <= $1
    AND(data->'time'->>'end'):: timestamp >= $2
  AND id NOT IN(
      SELECT sid
    FROM rental
    WHERE(data->'time'->>'end'):: timestamp > NOW()
    )
    AND($3::uuid IS NULL OR id = $3::uuid);
    `
    // Define the query object that will be passed to the database
    const QUERY = {
      text: SELECT,
      values: values
    };
    const { rows } = await pool.query(QUERY);
    console.log(rows);
    // RETURNING an Array of all AVAILABLE spots
    return rows.map(row => row.spot);
  }

  public async create(uid: UUID, data: any): Promise<Spot> {
    data.available = true;
    const INSERT = `
    INSERT INTO spot(data, uid) VALUES($1, $2)
    RETURNING(jsonb_build_object('id', id) || data) as ParkingSpot`;

    const QUERY = {
      text: INSERT,
      values: [
        `${JSON.stringify(data)}`,
        `${uid}`
      ]
    };
    try {
      const { rows } = await pool.query(QUERY);
      return rows[0].ParkingSpot;
    } catch(e) {
      console.log(e);
      throw e;
    }
  }

  public async getOwned(uid: string): Promise<Spot[]> {
    const SELECT = `SELECT jsonb_build_object('id', id, 'uid', uid) || data as spot from spot where uid = $1`
    const QUERY = {
      text: SELECT,
      values: [uid]
    }
    const { rows } = await pool.query(QUERY);
    return rows.map(row => row.spot);
  }

  public async getAllSpots(): Promise<Spot[]> {
    const SELECT = `
    SELECT
      (jsonb_build_object('id', spot.id, 'uid', spot.uid) || spot.data) as data
      FROM spot
      LEFT JOIN rental ON spot.id = rental.sid
    WHERE(
      to_timestamp((spot.data ->> 'time'):: jsonb ->> 'end', 'YYYY-MM-DD"T"HH24:MI:SS"Z"') > NOW() AND
      (
        rental.id IS NULL OR
          NOT(
          NOW() BETWEEN
            to_timestamp(rental.data ->> 'start', 'YYYY-MM-DD"T"HH24:MI:SS"Z"') AND
            to_timestamp(rental.data ->> 'end', 'YYYY-MM-DD"T"HH24:MI:SS"Z"')
        )
      )
    )
      `;

    const QUERY = {
      text: SELECT,
    };
    const { rows } = await pool.query(QUERY);
    return rows.map(row => row.data);
  }

}


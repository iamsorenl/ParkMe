import { UUID, ISOFormat } from "../custom";
import { Spot } from "../../types/spot";

/*
* sid : spot id
* uid : id of renter
* amount : amount renter paid owner
* end : end time of parking
*/
export interface Rental {
  sid: UUID,
  uid: UUID,
  amount: number,
  start: ISOFormat,
  end: ISOFormat,
}

/*
* extension adds id for rental
*/
export interface Rent extends  Rental{
  id: UUID,
}

/*
* sid : spot id
* amount : amount renter paid owner
* end : end time of parking
*/
export interface InputPostRental {
  sid: UUID,
  amount: number,
  start: ISOFormat,
  end: ISOFormat,
}


/*
* input for get rental by spot id
*/
export interface InputRentalWithSpot {
  sid: UUID,
}

/*
* input for get rental by user id
*/
export interface InputRentalWithUID {
  uid: UUID,
}

export interface RentedSpot extends Spot {
  amount: number,
  start: ISOFormat,
  end: ISOFormat,
}

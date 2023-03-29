import { UUID, ISOFormat } from "../custom";

/**
 * Paired object for latitude and longitude coordinates
 * Main use for map api
 * 
 * https://developers.google.com/maps/documentation/javascript/reference/coordinates
 */
export interface Coords {
    lat: number,
    long: number,
}

/**
 * Can modify for array of addr lines,
 * I think for our case one should be enough...
 * 
 * region and country to prevent loss of generality in case we go big
 */
export interface StreetAddress {
    addr: string,
    zipcode: string,
    locality: string,
    region: string,
    country: string,
}

/**
 * @description Parking Spot
 * @example 
 * {
 *    id: "123e4567-e89b-12d3-a456-426655440000",
 *    available: true,
 *    address: {
 *      addr: "1156 High St",
 *      zipcode: "95060",
 *      locality: "Santa Cruz",
 *      region: "California",
 *      country: "US"
 *    },
 *    coords: {
 *      lat: 36.95940725,
 *      long: -122.05787141794443
 *    },
 *    description: "Parking at UCSC",
 *    priceRate: 10
 *    name: "My Parking Spot"
 *  }
 * 
 * Please Note: priceRate should denote X amount of Currency on a per hour basis
 * 
 * 
 * NOTE: heavily consider a validation service for our inputs
 * while types are asserted there's no guarantees on length of some of these input fields
 * nor invalid characters. We should aim for alphanumeric chars allowing for emojis, and lengths of 500 char maximum
 */
export interface InputTypeSpot {
    time: {
        start: ISOFormat,
        end: ISOFormat,
    }
    address: StreetAddress,
    coords?: Coords,
    description: string,
    priceRate: number,
    date: string,
    name?: string,
    pictures?: string[],
}
export interface Spot extends InputTypeSpot {
    id: UUID,
    available: boolean,
}

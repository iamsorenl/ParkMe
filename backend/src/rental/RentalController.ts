import { Controller, Get, Route, Security, Response, Query, Request, Post, SuccessResponse, Body, Path } from "tsoa";
import { Rental, Rent, InputPostRental, RentedSpot } from "../types/rental";
import { RentalService } from "./RentalService";
import { SpotService } from "../spot/SpotService";
import { UUID } from "src/types/custom";

@Route("rental")
export class RentalController extends Controller {
  @Get()
  @Security("jwt", ["user"])
  public async getRentals(
    @Request() request: Express.Request
  ): Promise<Rent[]> {
    return new RentalService().getByRenterID(request.user.id);
  }

  @Get("{id}")
  @Security("jwt", ["user"])
  @Response("404", "Not Found")
  public async getByRentalID(
    @Path() id: string
  ): Promise<RentedSpot[] | undefined> {
    return new RentalService().getSpotsByRenterID(id); // check to see if spot exists in spot table

  }

  @Get("spot/{id}")
  @Security("jwt", ["user"])
  @Response("404", "Not Found")
  public async getBySpotID(
    @Path() id: string
  ): Promise<Rent[] | undefined> {
    console.log(`Received ID: ${id}`);
    const spot = await new SpotService().getByID(id); // check to see if spot exists in spot table
    const rental = await new RentalService().getBySpotID(id);
    if (!spot) {
      this.setStatus(404);
      return;
    }
    return rental;
  }
  


  @Post()
  @Security("jwt", ["user"])
  @Response("401", "Unauthorized")
  @Response("404", "Not Found")
  @Response("409", "Conflict")
  @Response("400", 'Bad Request')
  @SuccessResponse('201', 'Created')
  public async createRental(
    @Body() rentalInput: InputPostRental, // pass in the rental object in the request body
    @Request() request: Express.Request
  ): Promise<Rent | undefined> {
    const rentalService = new RentalService();
    const existingRentals = await rentalService.getBySpotID(rentalInput.sid);
    const existingSpot = await new SpotService().getByID(rentalInput.sid);
    //const newRental = await rentalService.createRental(rentalInput, request.user.id);
    const newStart = rentalInput.start;
    const newEnd = rentalInput.end;
    // unauthorized to rent your own spot
    if(existingSpot) {
      const spots = await new SpotService().getOwned(request.user.id);
      const spotIds = spots.map(spot => spot.id);
      if (spotIds.includes(existingSpot.id)) {
        this.setStatus(401);
        return;
      }
    }
    // check to see if times proposed are within bounds of the spot
    if (existingSpot) {
      const spotStart = new Date(existingSpot.time.start);
      const spotEnd = new Date(existingSpot.time.end);
      const rentalStart = new Date(newStart);
      const rentalEnd = new Date(newEnd);
      // check to make sure the time periods are within the bounds of the spot 
      if (rentalStart < spotStart || rentalEnd > spotEnd) {
        // console.log(rentalStart);
        // console.log(spotStart);
        // console.log(rentalEnd);
        // console.log(spotEnd);
        // console.log('first');
        this.setStatus(409);
        return;
      }
    }
    // should not be necessary if 
    /*
    // check to see if time doesnt conflict with existing spot
    if (existingRentals) {
      let i = 0;
      for (const rental of existingRentals) {
        i = i + 1;
        const rentalStart = new Date(rental.start);
        const rentalEnd = new Date(rental.end);
        const proposedStart = new Date(newStart);
        const proposedEnd = new Date(newEnd);
        if ((rentalStart <= proposedStart && proposedStart <= rentalEnd) || (rentalStart <= proposedEnd && proposedEnd <= rentalEnd)) {
          console.log('second');
          this.setStatus(409);
          //console.log(i);
          return;
        }
      }
      //console.log(i);
    }
    */
    // ensure that the spot in question exists
    if (!existingSpot) {
      this.setStatus(404);
      return
    } 

    return rentalService.createRental(rentalInput, request.user.id);
  }
}

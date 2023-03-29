import {
  Controller,
  Get,
  Post,
  Route,
  Security,
  Response,
  Body,
  Query,
  Request,
  SuccessResponse,
} from "tsoa";
import { Spot, InputTypeSpot } from "../types/spot";
import { ISOFormat, UUID } from "../types/custom";
import { UserPrivate } from "../types/user";
import { SpotService } from "./SpotService";

// Declare the route for this controller
@Route("spot")
export class SpotController extends Controller {
  /**
   * 
   * TODO: add the Security decorator to protect these routes
   * 
   * Gets a spot by its license plate.
   * @param id The license plate of the spot to retrieve.
   * @returns The matching spot, if found.
   */
  @Get("available")
  @Security("jwt", ["user"])
  @Response("422", "Invalid time range")
  public async getAllAvailableSpots(
    @Query() start?: ISOFormat,
    @Query() end?: ISOFormat,
    @Query() id?: UUID
  ) {
    //console.log(start, end);
    if (!start) start = new Date().toISOString();
    if (!end) end = new Date().toISOString();
    if (new Date(start) > new Date(end)) {
      this.setStatus(422);
      return
    }
    return new SpotService()
      .getAllAvailableSpots(start, end, id);
  }

  @Get("owned")
  @Security("jwt", ["user"])
  public async getOwned(
    @Request() request: Express.Request
  ): Promise<Spot[]> {
    return new SpotService().getOwned(request.user.id);
  }

  @Get("{id}")
  @Security("jwt", ["user"])
  @Response("404", "Not Found")
  public async getSpotByID(id: string): Promise<Spot | undefined> {
    // Call the getByLicensePlate method from the SpotService class to retrieve the spot
    return new SpotService()
      .getByID(id)
      .then(res => {
        if (!res)
          this.setStatus(404);
        else
          return res;
      })
  }

  @Post()
  @Security("jwt", ["user"])
  @Response("401", "Unauthorized")
  //@Response('409', 'Parking spot already exists')
  @SuccessResponse('201', 'Created')
  public async createSpot(
    @Body() ParkingSpot: InputTypeSpot,
    @Request() request: Express.Request,
  ): Promise<Spot> {

    // if (!start) start = new Date().toISOString();
    // if (!end) end = new Date().toISOString();

    const user = request.user as UserPrivate;
    // future require validation for duplicate spot
    return new SpotService().create(user.id, ParkingSpot);
  }
  
  @Get()
  @Security("jwt", ["user"])
  public async getAllSpots(): Promise<Spot[]> {
    return new SpotService().getAllSpots();
  }
}

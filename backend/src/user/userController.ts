import { UUID } from "../types/custom";
import { EditAccount } from "./types"
import {
  Body,
  Controller,
  Get,
  Path,
  Response,
  Post,
  Put,
  Route,
  Security,
  SuccessResponse
} from "tsoa";

import { UserPublic, UserPrivate } from "../types/user";
import { UserService } from "./userService";
import { CreateAccountArgs } from "./types";

// Declare the route for this controller
@Route("user")
export class UserController extends Controller {

  /**
   * Gets a user by ID.
   * @param id The ID of the user to retrieve.
   * @returns The matching user, if found.
   */
  @Get("{id}")
  @Security("jwt", ["user"])
  @Response('404', 'User Not Found')
  public async getUser(
    @Path() id: UUID
  ): Promise<UserPublic | undefined> {
    const res = await new UserService().select(id);
    if (!res) {
      this.setStatus(404)
    }
    return res;
  }

  /**
   * Adds a new user to the database.
   * @param user The user to add.
   * @returns The added user.
   */
  @Post()
  public async addUser(
    @Body() user: CreateAccountArgs
  ): Promise<UserPublic> {
    return new UserService().add(user);
  }

  /**
   * Updates a user's account information.
   * @param id The ID of the user to update.
   * @param payload The updated account information.
   * @returns The updated user, if found.
   */
  @Put("{id}")
  @Security("jwt", ["user"])
  @Response('404', 'User Not Found')
  @SuccessResponse("201", "Created")
  public async editAccount(
  @Path() id: UUID,
  @Body() payload: EditAccount
  ): Promise<UserPublic | undefined> {
    const res = await new UserService().edit(id, payload);
    if(!res){
      this.setStatus(404);
    }
    return res; 
  }
}

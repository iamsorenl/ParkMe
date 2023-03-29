import {
  Body,
  Controller,
  Response,
  Post,
  Route,
} from "tsoa";

import { UserCredentials, UserToken } from "../types/auth";
import { AuthService } from "./service";

@Route("login")
export class AuthController extends Controller {
  @Post()
  @Response("401", "Unauthorized")
  public async login(
    @Body() credentials: UserCredentials
  ): Promise<UserToken | undefined> {
    const user = await new AuthService().login(credentials);
    if (!user) {
      this.setStatus(401)
    }
    return user;
  }
}

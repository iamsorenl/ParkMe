import * as express from "express";

import { UserPrivate } from "../types/user"
import { AuthService } from "./service";


export function expressAuthentication(
  request: express.Request,
  // SecurityName must be present to compile. TSOA will try and pass 3 arguments
  securityName: string,
  scopes?: string[],
): Promise<string|UserPrivate> {
  return new AuthService().check(request, scopes);
}

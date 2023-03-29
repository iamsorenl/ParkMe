import { EMAIL } from "../custom"

export interface UserCredentials {
  email: EMAIL,
  password: string,
}

export interface UserToken {
  id: string,
  name: string,
  token: string,
}

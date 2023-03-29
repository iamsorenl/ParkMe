import { EMAIL } from "../types/custom";

export interface CreateAccountArgs {
    email: EMAIL
    password: string
    name: string
}

export interface EditAccount {
    email?: EMAIL,
    name?: string,
    phone?: string,
    license?: string,
    pfp?: string,
}

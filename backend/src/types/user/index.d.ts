import { SCOPES, UUID } from "../custom";

export interface UserPrivate {
    id: UUID,
    email: string,
    name: string,
    scopes: string[],
    password?: string
}

export interface UserPublic {
    id?: UUID,
    email: string,
    name: string,
    scopes?: SCOPES[]
}

export type SCOPES = "user" | "admin"

/**
 * Valid UUID Pattern
 * @pattern ^[0-9a-fA-F]{8}\b-[0-9a-fA-F]{4}\b-[0-9a-fA-F]{4}\b-[0-9a-fA-F]{4}\b-[0-9a-fA-F]{12}$
 * @example "123e4567-e89b-12d3-a456-426655440000"
 */
export type UUID = string

/**
 * Valid Email Pattern
 * @pattern ^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$
 * @example "someone@gmail.com"
 */
export type EMAIL = string;

// https://www.regextester.com/112232
/**
 * Valid ISO Pattern
 * @pattern ^(\d{4})-(\d{2})-(\d{2})T(\d{2}):(\d{2}):(\d{2}(?:\.\d*)?)((-(\d{2}):(\d{2})|Z)?)$
 * @example 2012-03-01T00:00:00Z
 */
export type ISOFormat = string;

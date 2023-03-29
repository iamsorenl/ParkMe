import { Storage } from '@google-cloud/storage';
import path from "path";
const serviceKey = path.join(process.cwd(), './.config.json')

export const storage = new Storage({
  keyFilename: serviceKey,
  projectId: process.env.GCLOUD_PROJECT_ID || "",
});

export const bucket = storage.bucket(
  process.env.GCLOUD_STORAGE_BUCKET||""
);

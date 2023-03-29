import { format } from 'util';
import {bucket} from "./setup";
import { URI } from './storage'

export class StorageService {
  public async uploadFile(file: any): Promise<URI> {
    const blob = bucket.file(file.originalname);
    const blobStream = blob.createWriteStream();
    return new Promise((resolve, reject) => {
      const loc = "";
      blobStream
        .on('error',(err: any) => {
          reject(new Error(err));
        })
        .on('finish', () =>
          resolve(
            format(
              `https://storage.googleapis.com/${bucket.name}/${blob.name}`
            )
          )
        )
        .end(file.buffer);
    });
  }

  public async create(files: Express.Multer.File[]): Promise<URI[]> {
    if (!files) throw new Error("empty request");
    const Promises: Promise<URI>[] = [];

    for (const file of files) {
      Promises.push(this.uploadFile(file));
    }
    return new Promise((resolve, reject) => {
      Promise.all(Promises)
        .then(res => resolve(res))
        .catch(err => reject(err));
    });
  }
}

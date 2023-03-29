import {
  Post,
  Route,
  UploadedFiles,
  Response,
  Security,
  Controller
} from "tsoa";

import { URI } from "./storage";
import { StorageService } from "./storageService";

@Route("upload")
export class FilesController extends Controller {

  @Post()
  @Security("jwt", ["user"])
  @Response("401", "Unauthorized")
  @Response("500", "Unexpected error")
  public async uploadFile(
      @UploadedFiles() files: Express.Multer.File[],
  ): Promise<URI[]|void> {
    try {
      const uris = await new StorageService().create(files);
      return uris;
    } catch (e) {
      console.error(`Error emitted while attempting to upload files: ${JSON.stringify(e)}`);
      return this.setStatus(500);
    }
  }
}

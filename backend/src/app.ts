import express, { urlencoded, Router, Response as ExResponse, Request as ExRequest } from "express";
import swaggerUi from "swagger-ui-express";
import { RegisterRoutes } from "../build/routes";
import cors from "cors";

const app: express.Express = express();

app.use(cors());
app.use(express.json())
app.use(
  urlencoded({
    extended: true
  })
)
app.use("/docs", swaggerUi.serve, async (_req: ExRequest, res: ExResponse) => {
  return res.send(
    swaggerUi.generateHTML(await import("../build/swagger.json"))
  );
});

const router = Router();
RegisterRoutes(router);
app.use('/', router);


export default app;

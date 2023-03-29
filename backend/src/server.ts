import dontenv from "dotenv"
dontenv.config()
import app from "./app";

const port = process.env.PORT;

app.listen(port, () => {
  console.log(`SwaggerUI running at http://localhost:${port}/docs`);
}
);

/**
 * useful setup links:
 * 1. https://tsoa-community.github.io/docs/live-reloading.html
 */

// app.use('/', (req, res) => {
//     res.send(`
//     <h1>ParkMe Server</h1>
//     <h3>
//     <div>Current Routes:</div>
//     </h3>
//     <div style="padding-bottom: 20px">/users/{userId}?name</div>
//     <img src="https://plattsburghcreativesigns.com/wp-content/uploads/2020/02/Parking-Signs.jpg"/>
// `);
// });

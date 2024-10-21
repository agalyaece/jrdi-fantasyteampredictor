import express from "express";
import cors from "cors";
import bodyParser from "body-parser";

import dotenv from "dotenv";
import { connectDB } from "./config/db.js";

import administrationRoutes from "./routes/administration.route.js"
import statisticsRoutes from "./routes/statistics.route.js"
import fantasyRoutes from "./routes/fantasy.route.js"

dotenv.config();

const app = express();
const PORT = process.env.PORT || 3000;

app.use(express.json());
app.use(bodyParser.json())
app.use(bodyParser.urlencoded({extended:false}))

const corsOption = {
    origin: "*",
    credentials: true,
    optionSuccessStatus:200
}

app.use(cors(corsOption))

app.use("/administration", administrationRoutes)
app.use("/statistics", statisticsRoutes )
app.use("/fantasy", fantasyRoutes)

app.listen(PORT, () => {
    connectDB();
    console.log(`server is running on port ${PORT}`)
})
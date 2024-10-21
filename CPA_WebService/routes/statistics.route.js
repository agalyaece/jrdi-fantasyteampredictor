import express from "express";
import { createStatistics } from "../controller/statistics.controller.js";
const router = express.Router();

router.post("/add_stats", createStatistics )

export default router;
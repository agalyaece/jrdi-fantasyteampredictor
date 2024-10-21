import express from "express";
import { teamPlayers } from "../controller/fantasy.controller.js";
const router = express.Router();

router.get("/:team_A/vs/:team_B/players", teamPlayers )

export default router;
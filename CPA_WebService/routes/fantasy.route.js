import express from "express";
import { oneTeamPlayers, teamPlayers } from "../controller/fantasy.controller.js";
const router = express.Router();

router.get("/:team_A/vs/:team_B/players", teamPlayers)
router.get("/:team_A/players", oneTeamPlayers)

export default router;
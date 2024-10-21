import express from "express";

import { createPlayers, createTeams, createTournament, getOnePlayer, getPlayers, getTeams, getTournaments, updatePlayer } from "../controller/administration.controller.js";

const router = express.Router();

router.put("/add_stats/:id", updatePlayer)
router.post("/add_tournament", createTournament)
router.post("/add_teams", createTeams)
router.post("/add_players", createPlayers)
router.get("/get_tournament", getTournaments)
router.get("/get_team", getTeams)
router.get("/get_player", getPlayers)
router.get("/getOnePlayer/:id", getOnePlayer)

export default router;

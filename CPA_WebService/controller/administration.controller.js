
import Tournament from "../models/administration/tournaments.module.js";
import Player from "../models/administration/players.module.js";
import Teams from "../models/administration/teams.module.js";

export const createTournament = async (req, res) => {
	const tournament = req.body; // user will send this data

	if (!tournament.name || !tournament.date_start ||!tournament.date_end || !tournament.organiser || !tournament.venue) {
		return res.status(400).json({ success: false, message: "Please provide all fields" });
	}

	const newTournament = new Tournament(tournament);

	try {
		await newTournament.save();
		res.status(201).json({ success: true, data: newTournament });
	} catch (error) {
		console.error("Error in Create tournament:", error.message);
		res.status(500).json({ success: false, message: "Server Error" });
	}
};


export const createTeams = async (req, res) => {
	const teams = req.body; // user will send this data

	if (!teams.tournament_name || !teams.team_A || !teams.team_B || !teams.date_start || !teams.date_end || !teams.time) {
		return res.status(400).json({ success: false, message: "Please provide all fields" });
	}

	const newTeams = new Teams(teams);

	try {
		await newTeams.save();
		res.status(201).json({ success: true, data: newTeams });
	} catch (error) {
		console.error("Error in Create teams:", error.message);
		res.status(500).json({ success: false, message: "Server Error" });
	}
};

export const createPlayers = async (req, res) => {
	const players = req.body; // user will send this data

	if (!players.tournament_name || !players.team_name || !players.player_name || !players.role || !players.nationality) {
		return res.status(400).json({ success: false, message: "Please provide all fields" });
	}

	const newPlayers = new Player(players);

	try {
		await newPlayers.save();
		res.status(201).json({ success: true, data: newPlayers });
	} catch (error) {
		console.error("Error in Create players:", error.message);
		res.status(500).json({ success: false, message: "Server Error" });
	}
};

export const getTournaments = async(req,res) => {
	Tournament.find()
    .then((data) => {
      res.status(201).json(data);

    })
    .catch((err) => {
      res.status(500).send(err.message);
      console.log(err);
    })
}

export const getTeams = async(req,res) => {
	Teams.find()
    .then((data) => {
      res.status(201).json(data);

    })
    .catch((err) => {
      res.status(500).send(err.message);
      console.log(err);
    })
}

export const getPlayers = async(req,res) => {
	Player.find()
    .then((data) => {
      res.status(201).json(data);

    })
    .catch((err) => {
      res.status(500).send(err.message);
      console.log(err);
    })
}


//get one player
export const getOnePlayer = async (req, res) => {
    const id = req.params.id;
    Player.findById(id)
        .then(data => { res.status(201).send(data) })
        .catch(err => {
            res.status(500).send(err.message);
            console.log(err);
        })
}

export const updatePlayer =  (req, res) => {
    const id = req.params.id;
    Player.findByIdAndUpdate(id, req.body, { new: true })
        .then(  () =>   res.status(200).json({ msg: "player Updated successfully" }))
        .catch(err => {
            res.status(500).send(err.message);
            console.log(err);
        })
}
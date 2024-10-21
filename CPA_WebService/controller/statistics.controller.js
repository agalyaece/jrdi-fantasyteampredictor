import Statistics from "../models/statistics/statistics.module.js";


export const createStatistics = async (req, res) => {
	const statistics = req.body; // user will send this data

	if (!statistics.tournament_name || !statistics.team_name ||!statistics.player_name || !statistics.matches_played || 
        !statistics.role || !statistics.runs || !statistics.wickets) {
		return res.status(400).json({ success: false, message: "Please provide all fields" });
	}

	const newStatistics = new Statistics(statistics);

	try {
		await newStatistics.save();
		res.status(201).json({ success: true, data: newStatistics });
	} catch (error) {
		console.error("Error in Create Statistics:", error.message);
		res.status(500).json({ success: false, message: "Server Error" });
	}
};
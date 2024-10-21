import mongoose from "mongoose";

const statisticsSchema = new mongoose.Schema({
    tournament_name: {
        type: String,
        required: true,
    },
    team_name: {
        type: String,
        required: true,
    },
    player_name: {
        type: String,
        required: true,
    },
    role: {
        type: String,
        required: true,
    },
    matches_played: {
        type: Number,
        required: true,
    },
    runs: {
        type: Number,
        required:true,
    },
    wickets: {
        type: Number,
        required:true,
    },
}, { timestamps: true })

const Statistics = mongoose.model("Statistics", statisticsSchema);

export default Statistics;

import mongoose from "mongoose";

const playerSchema = new mongoose.Schema({
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
    nationality: {
        type: String,
        required: true,
    },
    matches_played: {
        type: Number,
        
    },
    runs: {
        type: Number,
        
    },
    wickets: {
        type: Number,
        
    },
}, { timestamps: true })

const Player = mongoose.model("Player", playerSchema);

export default Player;

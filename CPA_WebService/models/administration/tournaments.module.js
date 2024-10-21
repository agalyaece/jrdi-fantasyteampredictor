import mongoose from "mongoose";

const tournamentSchema = new mongoose.Schema({
    name: {
        type: String,
        required: true,
    },
    date_start: {
        type: Date,
        required: true,
    },
    date_end: {
        type: Date,
        required: true,
    },
    venue: {
        type: String,
        required: true,
    },
    organiser: {
        type: String,
        required: true,
    },
}, { timestamps: true })


const Tournament = mongoose.model("Tournament", tournamentSchema);

export default Tournament;
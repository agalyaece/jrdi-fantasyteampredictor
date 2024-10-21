import mongoose from "mongoose";

const teamsSchema = new mongoose.Schema({
    tournament_name: {
        type: String,
        required: true,
    },
    team_A: {
        type: String,
        required: true,
    },
    team_B: {
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
    time: {
        type: String,
        required: true,
        validate: {
          validator: function (value) {
            // Optional: Validate time format (HH:MM)
            const regex = /^(?:[01]\d|2[0-3]):[0-5]\d$/;
            return regex.test(value);
          },
          message: 'Invalid time format. Please use HH:MM'
        }
    },

}, { timestamps: true })


const Teams = mongoose.model("Team", teamsSchema);

export default Teams;
import { Link, useNavigate, useParams } from "react-router-dom";
import axios from "../../axios.js"
import { useEffect, useState } from "react";
import toast from "react-hot-toast";
import Input from "../../components/Input";
import Button from "../../components/Button.jsx"

export default function AddStatistics() {

    const { id } = useParams()
    const navigate = useNavigate()
    const players = {
        tournament_name: "",
        team_name: "",
        player_name: "",
        role: "",
        matches_played: "",
        runs: "",
        wickets: ""
    }
    const [player, setPlayer] = useState(players);
    const [buttonDisabled, setButtonDisabled] = useState(false);
    const handleUpdateInput = (event) => {
        const { name, value } = event.target;
        setPlayer({ ...player, [name]: value })
    }

    useEffect(() => {
        axios.get(`/administration/getOnePlayer/${id}`)
            .then((response) => {
                setPlayer(response.data)
            })
            .catch((err) => console.log(err))
    }, [id])

    function handleUpdatePlayer(event) {
        event.preventDefault();
        setButtonDisabled(true);

        axios.put(`/administration/add_stats/${id}`, player)
            .then((response) => {
                setButtonDisabled(false);
                toast.success(response.data.msg, { position: "top-right" })
                navigate("/statistics")

            })
            .catch((error) => alert(error.message))
    }

    return <>

        <form onSubmit={handleUpdatePlayer}>
            <h2>Welcome!</h2>
            <p>This is the page to add a new Player Statistics 🚀</p>

            <Input
                label="Player Name"
                id="player_name"
                type="text"
                name="player_name"
                onChange={handleUpdateInput}
                value={player.player_name}
                required
            />

            <Input
                label="Role"
                id="role"
                type="text"
                name="role"
                onChange={handleUpdateInput}
                value={player.role}
                required
            />


            <div className="control-row">
                <Input
                    label="Tournament Name"
                    id="tournament_name"
                    type="text"
                    name="tournament_name"
                    onChange={handleUpdateInput}
                    value={player.tournament_name}
                    required
                />

                <Input
                    label="Team Name"
                    id="team_name"
                    type="text"
                    name="team_name"
                    onChange={handleUpdateInput}
                    value={player.team_name}
                    required
                />

            </div>

            <Input
                label="Number of Matches Played"
                id="matches_played"
                type="number"
                pattern="^[0-9\b]+$"
                min={0} step={1}
                name="matches_played"
                onChange={handleUpdateInput}
                value={player.matches_played}
                required
            />

            <div className="control-row">
                <Input
                    label="Runs"
                    id="runs"
                    type="number"
                    pattern="^[0-9\b]+$"
                    min={0} step={1}
                    name="runs"
                    onChange={handleUpdateInput}
                    value={player.runs}
                    required
                />


                <Input
                    label="Wickets"
                    id="wickets"
                    type="number"
                    pattern="^[0-9\b]+$"
                    min={0} step={1}
                    name="wickets"
                    onChange={handleUpdateInput}
                    value={player.wickets}
                    required
                />
            </div>

           

            <p className="form-actions">

                <Link to={"/statistics"}>
                    <Button type="button" className="button button-flat">
                        Cancel
                    </Button>
                </Link>
                <Button
                    type="submit"
                    disabled={buttonDisabled}
                >
                    Add Player Data
                </Button>
            </p>
        </form>
    </>
}
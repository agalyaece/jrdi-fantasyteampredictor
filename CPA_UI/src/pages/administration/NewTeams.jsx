import { useEffect, useState } from "react";
import { Link, useNavigate } from "react-router-dom";
import toast from "react-hot-toast";

import axios from "../../axios.js"

import Input from "../../components/Input";
import Button from "../../components/Button.jsx";
import { useInput } from "../../hooks/useInput";
import { isNotEmpty } from "../../util/Validation";


export default function NewTeams() {
    const [buttonDisabled, setButtonDisabled] = useState(false);
    const [selectTournament, setSelectTournament] = useState();
    const [fetchedTournaments, setFetchedTournaments] = useState([]);
    const navigate = useNavigate()

    const {
        value: team_aValue,
        handleInputChange: handleteam_aChange,
        handleInputBlur: handleteam_aBlur,
        hasError: team_aHasError,
    } = useInput('', (value) => isNotEmpty(value));

    const {
        value: team_bValue,
        handleInputChange: handleteam_bChange,
        handleInputBlur: handleteam_bBlur,
        hasError: team_bHasError,
    } = useInput('', (value) => isNotEmpty(value));

    async function fetchTournament() {
        try {
            const response = await axios.get('/administration/get_tournament');
            setFetchedTournaments(response.data);
        } catch (error) {
            console.debug('Error fetching tournaments:', error);
        }
    }

    useEffect(() => {
        fetchTournament();
    }, [])

    function handleSelectTournament(event) {
        setSelectTournament(event)
    }

    function handleSubmit(event) {
        event.preventDefault();
        const fd = new FormData(event.target);
        const data = Object.fromEntries(fd.entries());
        setButtonDisabled(true)
        axios.post("/administration/add_teams", data).
            then(() => {
                setButtonDisabled(false);
                toast.success("Teams added successfully!", { position: "top-right" });
                navigate(`/administration`);
            })
            .catch((error) => {
                console.error(error);
                setButtonDisabled(false);
                toast.error("An error occurred while adding Teams. Please try again later.", { position: "top-right" });
            })
    }

    return <>
        <form onSubmit={handleSubmit}>
            <h2>Welcome Administrator!</h2>
            <p>This is the page to add a new Teams for your Tournaments 🚀</p>

            <div className="control-row">
                <Input
                    label="Team A"
                    id="team_A"
                    type="text"
                    name="team_A"
                    onBlur={handleteam_aBlur}
                    onChange={handleteam_aChange}
                    value={team_aValue}
                    error={team_aHasError && 'Please enter a valid team name!'}
                    required
                />

                <Input
                    label="Team B"
                    id="team_B"
                    type="text"
                    name="team_B"
                    onBlur={handleteam_bBlur}
                    onChange={handleteam_bChange}
                    value={team_bValue}
                    error={team_bHasError && 'Please enter a valid team name!'}
                    required
                />
            </div>

            <div className="control">
                <label htmlFor="tournament_name">Tournament</label>
                <select
                    id="tournament_name"
                    name="tournament_name"
                    value={selectTournament}
                    onChange={(e) => handleSelectTournament(e.target.value)}
                >
                    <option value="">Select Tournament</option>
                    {fetchedTournaments && fetchedTournaments.map((tournament) => (
                        <option value={tournament.name} key={tournament._id}>
                            {tournament.name}
                        </option>
                    ))}

                </select>
            </div>

            <div className="control-row">
                <div className="control">
                    <label htmlFor="date_start">Match - Start</label>
                    <input type="date" id="date_start" name="date_start" required />
                </div>

                <div className="control">
                    <label htmlFor="date_end">Match -End</label>
                    <input type="date" id="date_end" name="date_end" required />
                </div>


            </div>

            <div className="control">
                <label htmlFor="time">Match Time (IST)</label>
                <input type="time" id="time" name="time" required />
            </div>

            <p className="form-actions">
                <Link to={"/administration"}>
                    <Button type="button" className="button button-flat">
                        Cancel
                    </Button>
                </Link>
                <Button
                    type="submit"
                    disabled={buttonDisabled}
                >
                    Add Teams
                </Button>
            </p>
        </form>
    </>
}
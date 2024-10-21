import { Link, useNavigate } from "react-router-dom";
import { useEffect, useState } from "react";
import toast from "react-hot-toast";

import Input from "../../components/Input";
import Button from "../../components/Button";
import { useInput } from "../../hooks/useInput";
import { isNotEmpty } from "../../util/Validation";

import axios from "../../axios.js"

export default function NewPlayer() {
    const [buttonDisabled, setButtonDisabled] = useState(false);
    const [selectTournament, setSelectTournament] = useState();
    const [fetchedTournaments, setFetchedTournaments] = useState([]);
    const [selectTeam, setSelectTeam] = useState()
    const [fetchedTeam, setFetchedTeam] = useState([]);
    const navigate = useNavigate()

    const {
        value: nameValue,
        handleInputChange: handleNameChange,
        handleInputBlur: handleNameBlur,
        hasError: nameHasError,
    } = useInput('', (value) => isNotEmpty(value));

    const {
        value: nationalityValue,
        handleInputChange: handleNationalityChange,
        handleInputBlur: handleNationalityBlur,
        hasError: nationalityHasError,
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

    async function fetchTeam() {
        try {
            const data = await axios.get('/administration/get_team');
            setFetchedTeam(data.data);
        } catch (error) {
            console.debug('Error fetching teams:', error);
        }
    }

    useEffect(() => {
        fetchTeam();
    }, [])

    function handleSelectTeam(event) {
        setSelectTeam(event)
    }

    function handleSubmit(event) {
        event.preventDefault();
        const fd = new FormData(event.target);
        const data = Object.fromEntries(fd.entries());
        setButtonDisabled(true)
        axios.post("/administration/add_players", data).
            then(() => {
                setButtonDisabled(false);
                toast.success("Player added successfully!", { position: "top-right" });
                navigate(`/administration`);
            })
            .catch((error) => {
                console.error(error);
                setButtonDisabled(false);
                toast.error("An error occurred while adding Player data. Please try again later.", { position: "top-right" });
            })
    }

    return <>
        <form onSubmit={handleSubmit}>
            <h2>Welcome Administrator!</h2>
            <p>This is the page to add a new Player for specific teams 🚀</p>
            <Input
                label="Player Name"
                id="player_name"
                type="text"
                name="player_name"
                onBlur={handleNameBlur}
                onChange={handleNameChange}
                value={nameValue}
                error={nameHasError && 'Please enter a valid player name!'}
                required
            />
            <div className="control-row">
                <Input
                    label="Nationality"
                    id="nationality"
                    type="text"
                    name="nationality"
                    onBlur={handleNationalityBlur}
                    onChange={handleNationalityChange}
                    value={nationalityValue}
                    error={nationalityHasError && 'Please enter a valid Nationality!'}
                    required
                />
                <div className="control">
                    <label htmlFor="role">Role</label>
                    <select id="role" name="role">
                        <option value="">Select Role</option>
                        <option value="Batter">Batter</option>
                        <option value="Bowler">Bowler</option>
                        <option value="Allrounder">AllRounder</option>
                        <option value="Wicketkeeper">WicketKeeper</option>
                    </select>
                </div>
            </div>
            <div className="control-row">
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
                <div className="control">
                    <label htmlFor="team_name">Team Belongs to</label>
                    <select
                        id="team_name"
                        name="team_name"
                        value={selectTeam}
                        onChange={(e) => handleSelectTeam(e.target.value)}
                    >
                        <option value="">Select Team</option>
                        {fetchedTeam &&
                            fetchedTeam.reduce((seenCountries, team) => {
                                const uniqueCountries = new Set([team.team_A, team.team_B]);

                                // Check if any country from the current team is already seen
                                const hasSeenCountry = seenCountries.some((seenCountry) =>
                                    uniqueCountries.has(seenCountry)
                                );

                                // Only render options if neither team_A nor team_B is already included
                                if (!hasSeenCountry) {
                                    // Convert uniqueCountries to an array for using map
                                    const uniqueCountriesArray = Array.from(uniqueCountries);

                                    // Update seenCountries with all countries from the current team
                                    const updatedSeenCountries = [...seenCountries, ...uniqueCountriesArray];
                                    return [
                                        ...updatedSeenCountries,
                                        ...uniqueCountriesArray.map((country) => (
                                            <option key={country} value={country}>
                                                {country}
                                            </option>
                                        )),
                                    ];
                                } else {
                                    return seenCountries; // Skip rendering if already seen
                                }
                            }, [])}
                    </select>
                </div>
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
                    Add Player
                </Button>
            </p>
        </form>
    </>
}
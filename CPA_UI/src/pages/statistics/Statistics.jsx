import { useEffect, useState } from "react"
import { Link } from "react-router-dom"
import axios from "../../axios.js"
import Button from "../../components/Button.jsx"


export default function Statistics() {
    const [fetchedEvents, setFetchedEvents] = useState([])


    async function fetchData() {
        const data = await axios.get("/administration/get_player")
        
        setFetchedEvents(data)
    }

    useEffect(() => {
        fetchData();
    }, [])



    return <>
        <div>
            <h2 style={{ textAlign: 'center', color:"gray" }} >Player Statistics</h2>
            <table>
                <thead>
                    <tr>
                        <th scope="col">Tournament</th>
                        <th scope="col">Team</th>
                        <th scope="col">Player</th>
                        <th scope="col">Matches played</th>
                        <th scope="col">Runs</th>
                        <th scope="col">Wickets</th>
                        <th scope="col">Action</th>
                    </tr>
                </thead>
                <tbody>
                    {fetchedEvents.data && fetchedEvents?.data.map((player, index) => (
                        <tr key={index} >
                            <td scope="row">{player.tournament_name}</td>
                            <td>{player.team_name}</td>
                            <td>{player.player_name} ({player.role})</td>
                            <td>{player.matches_played}</td>
                            <td>{player.runs}</td>
                            <td>{player.wickets}</td>
                            <td>
                                <Link to={`/administration/getOnePlayer/${player._id}`}>
                                    <Button>
                                        Edit
                                    </Button>
                                </Link>
                            </td>
                        </tr>
                    ))}

                </tbody>
            </table>
        </div>



    </>
}
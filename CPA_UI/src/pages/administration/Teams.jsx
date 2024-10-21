import { useEffect, useState } from "react";
import axios from "../../axios.js"

function Teams() {
    const [isLoading, setIsLoading] = useState(false);
    const [error] = useState();
    const [fetchedEvents, setFetchedEvents] = useState()

    async function fetchData() {
        setIsLoading(true)
        const data = await axios.get("/administration/get_team")
        setFetchedEvents(data)
        setIsLoading(false)
    }

    useEffect(() => {
        fetchData()
    }, [])

    return <>
        <div style={{ textAlign: 'center' }}>
            {isLoading && <p style={{ color: '#066021' }} >Loading...</p>}
            {error && <p style={{ color: '#066021' }}>{error}</p>}
        </div>
        <div className="selected-player-wrapper">
            <h3 style={{ color: '#066021', textAlign: 'center', fontWeight: "bolder" }}>Teams Here</h3>
            {!isLoading && fetchedEvents && fetchedEvents.data.map((team) => {
                return (
                    <ul key={team._id} className="custom-input" >
                        <li className="players"> {team.team_A} VS {team.team_B} </li>
                    </ul>

                )
            })}
        </div>


    </>
}

export default Teams;
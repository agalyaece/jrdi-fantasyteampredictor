import { useEffect, useState } from "react";
import axios from "../../axios.js"

function Tournament() {
    const [isLoading, setIsLoading] = useState(false);
    const [error] = useState();
    const [fetchedEvents, setFetchedEvents] = useState()

    async function fetchData() {
        setIsLoading(true)
        const data = await axios.get("/administration/get_tournament")
        setFetchedEvents(data)
        setIsLoading(false)
    }

    useEffect(() => {
        fetchData()
    }, [])

    return <>
        <div style={{ textAlign: 'center' }}>
            {isLoading && <p style={{ color: '#066021' }}>Loading...</p>}
            {error && <p style={{ color: '#066021' }}>{error}</p>}
        </div>
        <div className="selected-player-wrapper">
        <h3 style={{ color: '#066021', textAlign: 'center', fontWeight: "bolder" }}>Tournaments Here</h3>
        {!isLoading && fetchedEvents && fetchedEvents.data.map((tournament) => {
            return (
                <ul key={tournament._id} className="custom-input" >
                    <li className="players"> {tournament.name} </li>
                </ul>
                
            )
        })}
        </div>
    </>
}

export default Tournament;
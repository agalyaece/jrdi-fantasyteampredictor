import { useEffect, useState } from "react";
import axios from "../../axios.js"
import NewMatch from "./NewMatch.jsx";
import OldMatch from "./OldMatch.jsx";

export default function Matches() {
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
            {isLoading && <p style={{ color: 'gray' }}>Loading...</p>}
            {error && <p style={{ color: 'gray' }}>{error}</p>}
        </div>

        <h2 style={{ color: 'gray' }}>Upcoming Matches</h2>
        {!isLoading && fetchedEvents && <NewMatch events={fetchedEvents}/>}
        <h2 style={{ color: 'gray' }}>Old Matches</h2>
        {!isLoading && fetchedEvents && <OldMatch events={fetchedEvents}/>}
    </>
}
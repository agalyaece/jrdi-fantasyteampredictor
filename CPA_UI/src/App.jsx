import { createBrowserRouter, RouterProvider } from "react-router-dom"
import Root from "./pages/Root"
import Home from "./pages/Home"
import ErrorPage from "./pages/ErrorPage"
import Administation from "./pages/administration/Administration"

import NewTournament from "./pages/administration/NewTournament"
import NewTeams from "./pages/administration/NewTeams"
import NewPlayer from "./pages/administration/NewPlayer"
import Statistics from "./pages/statistics/Statistics"
import AddStatistics from "./pages/statistics/AddStatistics"
import Matches from "./pages/fantasy/Matches"
import Players from "./pages/fantasy/Players"

const router = createBrowserRouter([
    {
        path: "/",
        element: <Root />,
        errorElement: <ErrorPage />,
        children: [
            { index: true, element: <Home /> },
            {
                path: "administration",
                children: [
                    { index: true, element: <Administation /> },
                    { path: "add_tournament", element: <NewTournament /> },
                    { path: "add_teams", element: <NewTeams /> },
                    { path: "add_players", element: <NewPlayer /> },
                    { path: "getOnePlayer/:id", element: <AddStatistics /> },
                ]
            },
            {
                path: "statistics",
                children: [
                    { index: true, element: <Statistics /> },
                ]
            },
            {
                path: "fantasy",
                children: [
                    { index: true, element: <Matches /> },
                    {path:":team_A/vs/:team_B/players", element: <Players />}
                ]
            }
        ]
    }
])

function App() {
    return <RouterProvider router={router} />
}

export default App

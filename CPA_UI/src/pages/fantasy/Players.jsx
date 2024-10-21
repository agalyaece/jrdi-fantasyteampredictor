import { useCallback, useEffect, useState } from "react";
import { useParams } from "react-router-dom";

import axios from "../../axios.js";

export default function Players() {

  const { team_A, team_B } = useParams();

  const [isLoading, setIsLoading] = useState(false);
  const [error] = useState();
  const [teamAPlayer, setTeamAPlayer] = useState([]);
  const [teamBPlayer, setTeamBPlayer] = useState([]);
  const [selectedPlayers, setSelectedPlayers] = useState([]);

  const fetchPlayers = useCallback(async () => {
    try {
      setIsLoading(true);
      const data = await axios.get(`/fantasy/${team_A}/vs/${team_B}/players`);
      const players = data.data;
      console.log(players);
      setTeamAPlayer(players.filter((player) => player.team_name === team_A));
      setTeamBPlayer(players.filter((player) => player.team_name === team_B));
      setIsLoading(false);
    } catch (error) {
      console.log(error);
    }
  }, [team_A, team_B]);

  const handleCheckboxChange = (player) => {
    const newSelectedPlayers = [...selectedPlayers];
    const existingIndex = newSelectedPlayers.findIndex((p) => p._id === player._id);

    if (existingIndex !== -1) {
      newSelectedPlayers.splice(existingIndex, 1);
    } else {
      if (selectedPlayers.length >= 11) {
        // Maximum 11 players allowed
        alert("You can select a maximum of 11 players.");
        return;
      }

      if (
        (player.team_name === team_A && selectedPlayers.filter(p => p.team_name === team_A).length >= 7) ||
        (player.team_name === team_B && selectedPlayers.filter(p => p.team_name === team_B).length >= 7)
      ) {
        // Maximum 7 players per team
        alert("You can select a maximum of 7 players from each team.");
        return;
      }

      newSelectedPlayers.push(player);
    }

    setSelectedPlayers(newSelectedPlayers);
  };

  useEffect(() => {
    fetchPlayers();
  }, [fetchPlayers]);

  return (
    <>
      {isLoading ? (
        <p style={{ color: 'gray' }}>Loading...</p>
      ) : error ? (
        <p style={{ color: 'gray' }}>Error fetching data: {error.message}</p>
      ) : (
        <>
        <p style={{ color: '#066021', textAlign: 'center', fontWeight: "bolder" }} >You can select only 7 from each team </p>
          <div className="container">
            <div className="grid">

              <div className="element">

                <h4>Playing-XI {team_A}</h4>
                <table>
                  <thead>
                    <tr>
                      <td>  </td>
                      <td>Name</td>
                      <td>Role</td>
                      <td>matches played</td>
                      <td>runs</td>
                      <td>wicket points</td>

                    </tr>
                  </thead>
                  <tbody>
                    {teamAPlayer.map((player) => (
                      <tr key={player._id}>
                        <th> <input
                          type="checkbox"
                          id={player.player_name}
                          name="acquisition"
                          value={player.player_name}
                          checked={selectedPlayers.includes(player)}
                          onChange={() => handleCheckboxChange(player)}
                        />
                        </th>
                        <td> <label htmlFor={player.player_name}>{player.player_name}</label></td>
                        <td>{player.role}</td>
                        <td>{player.matches_played}</td>
                        <td>{player.runs}</td>
                        <td>{player.wickets}</td>

                      </tr>
                    ))}
                  </tbody>
                </table>
                
              </div>

              <div className="element">
              <h4>Playing-XI {team_B}</h4>
                <table>
                  <thead>
                    <tr>
                      <td>  </td>
                      <td>Name</td>
                      <td>Role</td>
                      <td>matches played</td>
                      <td>runs</td>
                      <td>wicket points</td>
                    </tr>
                  </thead>
                  <tbody>
                    {teamBPlayer.map((player) => (
                      <tr key={player._id}>
                        <th> <input
                          type="checkbox"
                          id={player.player_name}
                          name="acquisition"
                          value={player.player_name}
                          checked={selectedPlayers.includes(player)}
                          onChange={() => handleCheckboxChange(player)}
                        />
                        </th>
                        <td> <label htmlFor={player.player_name}>{player.player_name}</label></td>
                        <td>{player.role}</td>
                        <td>{player.matches_played}</td>
                        <td>{player.runs}</td>
                        <td>{player.wickets}</td>

                      </tr>
                    ))}
                  </tbody>
                </table>
              </div>

            </div>
          </div>

          <div className="selected-player-wrapper">
            <h4>Selected Players:</h4>
            <ul className="custom-input">
              {selectedPlayers.map((player) => (
                <li className="players" key={player._id}>{player.player_name} - {player.role} ({player.team_name})</li>
              ))}
            </ul>
          </div>
        </>
      )}
    </>
  );
}
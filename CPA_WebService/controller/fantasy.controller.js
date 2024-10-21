import Player from "../models/administration/players.module.js";

const filterPlayers = async (team_A, team_B) => {
    try {
      const filteredData = await Player.find({
        team_name: { $in: [team_A, team_B] }
      });
      return filteredData
    } catch (error) {
      console.error('Error filtering players:', error);
      throw error;
    }
  };
  
  
export const teamPlayers =  async (req, res) => {
    const { team_A, team_B } = req.params;
    try {
      const filteredPlayers = await filterPlayers(team_A, team_B);
      // console.log('Filtered players:', filteredPlayers); // Add for debugging
      res.json(filteredPlayers);
    } catch (error) {
      console.error('Error in route:', error);
      res.status(500).json({ error: error.message });
    }
  }
  
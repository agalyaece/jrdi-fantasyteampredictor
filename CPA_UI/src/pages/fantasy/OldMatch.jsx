import PropTypes from "prop-types"
import { getCurrentDate } from "../../util/GetDate.js";
import { Link } from "react-router-dom";

function OldMatch({ events }) {
    return (
        <div className="tours">
            {events.data && events?.data.map((team) => {
                return (

                    <Link to={"/"} key={team._id}>
                        <div className="cardgroup" >
                            {team.date_start < getCurrentDate() &&

                                <div className="cardbody"  >
                                    <h3 style={{ color: 'black' }} >{team.tournament_name}</h3>
                                    <h3 style={{ color: 'black' }}>{team.team_A} VS {team.team_B}</h3>
                                    <p style={{ color: 'black' }}>{new Date(team.date_start).toLocaleDateString()} - {team.time} Hours</p>
                                </div>

                            }
                        </div>

                    </Link>
                )
            })}
        </div>
    )
}


OldMatch.propTypes = {
    events: PropTypes.any,
};


export default OldMatch;
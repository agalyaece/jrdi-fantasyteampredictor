import { Link } from "react-router-dom";

export default function SideBar() {
    return <>
        <aside >
            <h3 >
                Administrator Specific
            </h3>
            <div>
                <Link to={"/administration/add_tournament"}>
                    <button >
                        + Add Tournament
                    </button>
                </Link>

                <Link to={"/administration/add_teams"}>
                    <button >
                        + Add Teams
                    </button>
                </Link>

                <Link to={"/administration/add_players"}>
                    <button >
                        + Add Players
                    </button>
                </Link>
            </div>

        </aside>
    </>
}
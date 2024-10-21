import { Link } from "react-router-dom";


export default function Header() {
    return (
        <header>
            <Link to="/" >
                <h1 >Cricketer&apos;s Performance Analyzer </h1>
            </Link>
        </header>
    )
}
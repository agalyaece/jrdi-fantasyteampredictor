import Players from "./Players";
import SideBar from "./SideBar";
import Teams from "./Teams";
import Tournament from "./Tournament";


export default function Administation() {
    return <>
        <SideBar />
        <main>
            <Tournament />
            <Teams />
            <Players />
        </main>
    </>

}
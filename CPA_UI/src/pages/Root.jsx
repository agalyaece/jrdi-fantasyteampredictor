import { Outlet } from "react-router-dom";
import Header from "../components/Header.jsx";
import MainNavigation from "../components/MainNavigation.jsx";
import Footer from "../components/Footer.jsx";


export default function Root  ()  {
  return <>
  <Header />
  <MainNavigation />
  <main>
    <Outlet />
  </main>
  <Footer />
  
  </>
}

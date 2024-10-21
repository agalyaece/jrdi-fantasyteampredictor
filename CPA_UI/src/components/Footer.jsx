

export default function Footer(){

    const year = new Date().getFullYear();
    return(
        <footer >
            Copyright © JRD tech {year}
        </footer>
    );
}
import Footer from '../components/Footer';
import Header from '../components/Header';
import MainNavigation from '../components/MainNavigation';

function ErrorPage() {
    return (
        <>
            <Header />
            <MainNavigation />
            <main>
                <h1>An error occurred!</h1>
                <p style={{ color: '#2b2b2b' }}>Could not find this page!</p>
            </main>
            <Footer />
        </>
    );
}

export default ErrorPage;
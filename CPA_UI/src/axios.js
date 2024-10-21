import axios from "axios";

const instance = axios.create({

    baseURL: "http://localhost:3000"
    // baseURL: "https://t-20-backend-3.onrender.com"
});

export default instance;
import Echo from "laravel-echo";
import Pusher from "pusher-js";

window.Pusher = Pusher;

// Get token saved by api.js
const token = localStorage.getItem("api_token") || null;

const echo = new Echo({
    broadcaster: "pusher",
    key: import.meta.env.VITE_PUSHER_APP_KEY,
    cluster: import.meta.env.VITE_PUSHER_APP_CLUSTER,
    forceTLS: true,

    // Use the API endpoint
    authEndpoint: "http://mini-attendance.test/api/broadcasting/auth",
    auth: {
        headers: {
            Authorization: token ? `Bearer ${token}` : "",
            Accept: "application/json",
        },
    },
});

export default echo;
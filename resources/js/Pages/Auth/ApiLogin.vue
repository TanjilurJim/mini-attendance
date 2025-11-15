<script setup>
import { ref } from "vue";
import api, { setToken } from "@/utils/api"; // if @ alias isn't configured, use relative path
// import { router } from '@inertiajs/vue3' // optional — commented out to avoid Ziggy/inertia issues

const email = ref("admin@example.com");
const password = ref("secret"); // set for testing or leave empty
const device_name = ref("web");
const error = ref(null);
const loading = ref(false);

async function submit() {
    error.value = null;
    loading.value = true;

    try {
        const payload = {
            email: email.value,
            password: password.value,
            device_name: device_name.value || "web",
        };

        // using your api wrapper (baseURL '/api')
        const res = await api.post("/sanctum/token", payload);

        // Accept any 2xx, but ensure token exists
        if (res && res.data && res.data.token) {
            // Persist and configure axios
            setToken(res.data.token);

            // Optional: persist user object
            if (res.data.user) {
                localStorage.setItem("me", JSON.stringify(res.data.user));
            }

            console.log("Token received, redirecting."); // debug
            // Redirect safely (no Ziggy / Inertia dependency)
            window.location.href = "/students";
            return;
        }

        // If no token, show returned message or fallback
        error.value = res?.data?.message || "Login failed: no token returned";
        console.warn("Token endpoint returned but token not present", res);
    } catch (err) {
        // Preferably show helpful server error message
        if (err.response && err.response.data) {
            const d = err.response.data;
            error.value =
                d.message ||
                (d.errors ? JSON.stringify(d.errors) : "Login failed");
        } else {
            error.value = "Network or server error";
        }
        console.error("API login error", err);
    } finally {
        loading.value = false;
    }
}

// if already logged in, redirect automatically
if (localStorage.getItem("api_token")) {
    // already have token — go to SPA
    // you may want to verify token by calling /api/health or /api/students
    window.location.href = "/students";
}
</script>

<template>
    <div class="max-w-lg mx-auto p-8">
        <h2 class="text-xl mb-4">API Login</h2>

        <div v-if="error" class="text-red-600 mb-4">{{ error }}</div>

        <div class="mb-4">
            <label class="block text-sm">Email</label>
            <input v-model="email" type="email" class="w-full border p-2" />
        </div>

        <div class="mb-4">
            <label class="block text-sm">Password</label>
            <input
                v-model="password"
                type="password"
                class="w-full border p-2"
            />
        </div>

        <div class="mb-4">
            <label class="block text-sm">Device name</label>
            <input
                v-model="device_name"
                type="text"
                class="w-full border p-2"
            />
        </div>

        <button
            :disabled="loading"
            @click.prevent="submit"
            class="px-4 py-2 bg-blue-600 text-white"
        >
            {{ loading ? "Logging in…" : "Login (get token)" }}
        </button>
    </div>
</template>

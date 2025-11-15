<script setup>
import { ref } from "vue";
import { useRouter } from "vue-router";
import api, { setToken } from "@/utils/api";

const router = useRouter();

const form = ref({
    email: "admin@example.com",
    password: "secret",
    device_name: "web",
});

const loading = ref(false);
const error = ref(null);

async function handleLogin() {
    error.value = null;
    loading.value = true;

    try {
        const res = await api.post("/sanctum/token", form.value);

        if (res.data && res.data.token) {
            // Save token
            setToken(res.data.token);

            // Save user data
            if (res.data.user) {
                localStorage.setItem("me", JSON.stringify(res.data.user));
            }

            // Redirect to dashboard
            router.push("/dashboard");
        } else {
            error.value = "Login failed: No token received";
        }
    } catch (err) {
        if (err.response && err.response.data) {
            const data = err.response.data;
            error.value =
                data.message || JSON.stringify(data.errors) || "Login failed";
        } else {
            error.value = "Network error. Please try again.";
        }
        console.error("Login error:", err);
    } finally {
        loading.value = false;
    }
}
</script>

<template>
    <div
        class="min-h-screen flex items-center justify-center bg-gray-50 py-12 px-4 sm:px-6 lg:px-8"
    >
        <div class="max-w-md w-full space-y-8">
            <!-- Header -->
            <div>
                <h2
                    class="mt-6 text-center text-3xl font-extrabold text-gray-900"
                >
                    📚 Mini Attendance System
                </h2>
                <p class="mt-2 text-center text-sm text-gray-600">
                    Sign in to your account
                </p>
            </div>

            <!-- Login Form -->
            <form @submit.prevent="handleLogin" class="mt-8 space-y-6">
                <div class="rounded-md shadow-sm -space-y-px">
                    <div>
                        <label for="email" class="sr-only">Email address</label>
                        <input
                            id="email"
                            v-model="form.email"
                            type="email"
                            required
                            class="appearance-none rounded-none relative block w-full px-3 py-2 border border-gray-300 placeholder-gray-500 text-gray-900 rounded-t-md focus:outline-none focus:ring-blue-500 focus:border-blue-500 focus:z-10 sm:text-sm"
                            placeholder="Email address"
                        />
                    </div>
                    <div>
                        <label for="password" class="sr-only">Password</label>
                        <input
                            id="password"
                            v-model="form.password"
                            type="password"
                            required
                            class="appearance-none rounded-none relative block w-full px-3 py-2 border border-gray-300 placeholder-gray-500 text-gray-900 rounded-b-md focus:outline-none focus:ring-blue-500 focus:border-blue-500 focus:z-10 sm:text-sm"
                            placeholder="Password"
                        />
                    </div>
                </div>

                <!-- Error Message -->
                <div v-if="error" class="rounded-md bg-red-50 p-4">
                    <div class="flex">
                        <div class="ml-3">
                            <h3 class="text-sm font-medium text-red-800">
                                {{ error }}
                            </h3>
                        </div>
                    </div>
                </div>

                <!-- Submit Button -->
                <div>
                    <button
                        type="submit"
                        :disabled="loading"
                        class="group relative w-full flex justify-center py-2 px-4 border border-transparent text-sm font-medium rounded-md text-white bg-blue-600 hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500 disabled:opacity-50 disabled:cursor-not-allowed"
                    >
                        <span v-if="loading">Logging in...</span>
                        <span v-else>Sign in</span>
                    </button>
                </div>

                <!-- Test Credentials -->
                <div class="text-xs text-center text-gray-500">
                    <p>Test credentials:</p>
                    <p>Email: admin@example.com</p>
                    <p>Password: secret</p>
                </div>
            </form>
        </div>
    </div>
</template>

<script setup>
import { ref, onMounted, onUnmounted } from "vue";
import echo from "@/utils/echo";
import { useRouter, useRoute } from "vue-router";
import api, { clearToken } from "@/utils/api";
import { useToast } from "vue-toastification";

const notifications = ref([]);
const notificationsOpen = ref(false);
const unreadCount = ref(0);
const bellAnimating = ref(false);
const router = useRouter();
const route = useRoute();
const user = ref(JSON.parse(localStorage.getItem("me") || "{}"));
const showMobileMenu = ref(false);
const toast = useToast();

let attendanceChannel = null;
let notificationDropdownRef = null;

async function logout() {
    try {
        await api.post("/sanctum/revoke");
    } catch (err) {
        console.error("Logout error:", err);
    } finally {
        clearToken();
        localStorage.removeItem("me");
        router.push("/login");
    }
}

function playNotify() {
    try {
        const audio = new Audio("/sounds/notify.mp3");
        audio.play().catch(() => {});
    } catch (e) {
        // ignore autoplay errors
    }
}

function toggleNotifications() {
    notificationsOpen.value = !notificationsOpen.value;
    
    // Mark as read when opening
    if (notificationsOpen.value && unreadCount.value > 0) {
        unreadCount.value = 0;
    }
}

function clearNotifications() {
    notifications.value = [];
    unreadCount.value = 0;
    notificationsOpen.value = false;
}

// Handle clicks outside the notification dropdown
function handleClickOutside(event) {
    if (notificationDropdownRef && !notificationDropdownRef.contains(event.target)) {
        notificationsOpen.value = false;
    }
}

// small helper to add a notification
function pushNotification(payload) {
    notifications.value.unshift({
        id: payload.id ?? Date.now(),
        text:
            payload.text ??
            (payload.sample
                ? `Attendance: ${payload.count ?? "?"} persons`
                : "Attendance updated"),
        payload,
        created_at: new Date().toISOString(),
    });
    unreadCount.value++;
}

const navItems = [
    { name: "Dashboard", path: "/dashboard", icon: "📊" },
    { name: "Students", path: "/students", icon: "👨‍🎓" },
    { name: "Attendance", path: "/attendance", icon: "✓" },
];

onMounted(() => {
    // Add click outside listener
    document.addEventListener("click", handleClickOutside);

    // Subscribe to private 'attendance' channel
    try {
        attendanceChannel = echo.private("attendance");

        attendanceChannel.listen(".attendance.recorded", (e) => {
            // e => payload: { class, months, count, sample, ... }
            playNotify();
            bellAnimating.value = true;
            pushNotification({
                id: Date.now(),
                text: `Attendance recorded (${e.count ?? "n"})`,
                ...e,
            });

            toast.info(`Attendance recorded (${e.count ?? "n"})`);
            
            // Reset animation after it completes
            setTimeout(() => {
                bellAnimating.value = false;
            }, 600);
        });
    } catch (err) {
        console.error("Echo subscription error:", err);
    }
});

onUnmounted(() => {
    // Remove click outside listener
    document.removeEventListener("click", handleClickOutside);

    try {
        if (attendanceChannel) {
            // attempt to leave channel to cleanup
            if (echo.leaveChannel) {
                echo.leaveChannel("attendance");
            } else if (echo.leave) {
                echo.leave("attendance");
            }
        }
    } catch (e) {
        // ignore
    }
});
</script>

<template>
    <div class="min-h-screen bg-gray-100">
        <!-- Navigation -->
        <nav class="bg-white shadow-lg">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div class="flex justify-between h-16">
                    <div class="flex">
                        <!-- Logo -->
                        <div class="flex-shrink-0 flex items-center">
                            <h1 class="text-xl font-bold text-blue-600">
                                📚 Mini Attendance
                            </h1>
                        </div>

                        <!-- Desktop Navigation -->
                        <div class="hidden sm:ml-6 sm:flex sm:space-x-8">
                            <router-link
                                v-for="item in navItems"
                                :key="item.path"
                                :to="item.path"
                                class="inline-flex items-center px-1 pt-1 border-b-2 text-sm font-medium"
                                :class="
                                    route.path === item.path
                                        ? 'border-blue-500 text-gray-900'
                                        : 'border-transparent text-gray-500 hover:border-gray-300 hover:text-gray-700'
                                "
                            >
                                <span class="mr-2">{{ item.icon }}</span>
                                {{ item.name }}
                            </router-link>
                        </div>
                    </div>

                    <!-- User menu + notifications -->
                    <div class="hidden sm:ml-6 sm:flex sm:items-center">
                        <div class="flex items-center space-x-4">
                            <!-- Notifications bell -->
                            <div class="relative" ref="notificationDropdownRef">
                                <button
                                    @click.stop="toggleNotifications"
                                    :class="[
                                        'p-2 rounded-md hover:bg-gray-100 relative',
                                        bellAnimating ? 'animate-ring' : '',
                                    ]"
                                >
                                    <svg
                                        class="h-6 w-6 text-gray-600"
                                        fill="none"
                                        stroke="currentColor"
                                        viewBox="0 0 24 24"
                                    >
                                        <path
                                            stroke-linecap="round"
                                            stroke-linejoin="round"
                                            stroke-width="2"
                                            d="M15 17h5l-1.405-1.405A2.032 2.032 0 0118 14.158V11a6 6 0 10-12 0v3.159c0 .538-.214 1.055-.595 1.436L4 17h5m6 0v1a3 3 0 11-6 0v-1m6 0H9"
                                        />
                                    </svg>

                                    <span
                                        v-if="unreadCount > 0"
                                        class="absolute -top-1 -right-1 inline-flex items-center justify-center px-2 py-0.5 text-xs font-bold leading-none text-white bg-red-600 rounded-full"
                                    >
                                        {{ unreadCount }}
                                    </span>
                                </button>

                                <!-- Dropdown -->
                                <transition
                                    enter-active-class="transition ease-out duration-200"
                                    enter-from-class="opacity-0 scale-95"
                                    enter-to-class="opacity-100 scale-100"
                                    leave-active-class="transition ease-in duration-150"
                                    leave-from-class="opacity-100 scale-100"
                                    leave-to-class="opacity-0 scale-95"
                                >
                                    <div
                                        v-if="notificationsOpen"
                                        @click.stop
                                        class="absolute right-0 mt-2 w-80 bg-white border rounded-lg shadow-xl z-50 overflow-hidden"
                                    >
                                        <div class="px-4 py-3 border-b bg-gray-50">
                                            <div class="flex items-center justify-between">
                                                <h3 class="text-sm font-semibold text-gray-900">
                                                    Notifications
                                                </h3>
                                                <span class="text-xs text-gray-500">
                                                    {{ notifications.length }} total
                                                </span>
                                            </div>
                                        </div>

                                        <!-- Notifications list -->
                                        <div v-if="notifications.length > 0" class="max-h-96 overflow-y-auto">
                                            <div
                                                v-for="n in notifications"
                                                :key="n.id"
                                                class="px-4 py-3 hover:bg-gray-50 border-b border-gray-100 transition-colors"
                                            >
                                                <div class="flex items-start">
                                                    <div class="flex-shrink-0">
                                                        <span class="text-2xl">✓</span>
                                                    </div>
                                                    <div class="ml-3 flex-1">
                                                        <p class="text-sm font-medium text-gray-900">
                                                            {{ n.text }}
                                                        </p>
                                                        <p class="text-xs text-gray-500 mt-1">
                                                            {{ new Date(n.created_at).toLocaleString() }}
                                                        </p>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>

                                        <!-- Empty state -->
                                        <div v-else class="px-4 py-8 text-center">
                                            <svg
                                                class="mx-auto h-12 w-12 text-gray-400"
                                                fill="none"
                                                stroke="currentColor"
                                                viewBox="0 0 24 24"
                                            >
                                                <path
                                                    stroke-linecap="round"
                                                    stroke-linejoin="round"
                                                    stroke-width="2"
                                                    d="M15 17h5l-1.405-1.405A2.032 2.032 0 0118 14.158V11a6 6 0 10-12 0v3.159c0 .538-.214 1.055-.595 1.436L4 17h5m6 0v1a3 3 0 11-6 0v-1m6 0H9"
                                                />
                                            </svg>
                                            <p class="mt-2 text-sm text-gray-500">No notifications yet</p>
                                        </div>

                                        <!-- Footer -->
                                        <div v-if="notifications.length > 0" class="px-4 py-3 bg-gray-50 border-t">
                                            <button
                                                @click="clearNotifications"
                                                class="w-full text-center text-sm font-medium text-red-600 hover:text-red-700 transition-colors"
                                            >
                                                Clear all notifications
                                            </button>
                                        </div>
                                    </div>
                                </transition>
                            </div>

                            <span class="text-sm text-gray-700">{{
                                user.name || "User"
                            }}</span>
                            <button
                                @click="logout"
                                class="px-4 py-2 text-sm font-medium text-white bg-red-600 rounded-md hover:bg-red-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-red-500"
                            >
                                Logout
                            </button>
                        </div>
                    </div>

                    <!-- Mobile menu button -->
                    <div class="flex items-center sm:hidden">
                        <button
                            @click="showMobileMenu = !showMobileMenu"
                            class="inline-flex items-center justify-center p-2 rounded-md text-gray-400 hover:text-gray-500 hover:bg-gray-100"
                        >
                            <span class="sr-only">Open main menu</span>
                            <!-- Icon -->
                            <svg
                                class="h-6 w-6"
                                fill="none"
                                viewBox="0 0 24 24"
                                stroke="currentColor"
                            >
                                <path
                                    stroke-linecap="round"
                                    stroke-linejoin="round"
                                    stroke-width="2"
                                    d="M4 6h16M4 12h16M4 18h16"
                                />
                            </svg>
                        </button>
                    </div>
                </div>
            </div>

            <!-- Mobile menu -->
            <div v-if="showMobileMenu" class="sm:hidden">
                <div class="pt-2 pb-3 space-y-1">
                    <router-link
                        v-for="item in navItems"
                        :key="item.path"
                        :to="item.path"
                        @click="showMobileMenu = false"
                        class="block pl-3 pr-4 py-2 border-l-4 text-base font-medium"
                        :class="
                            route.path === item.path
                                ? 'bg-blue-50 border-blue-500 text-blue-700'
                                : 'border-transparent text-gray-500 hover:bg-gray-50 hover:border-gray-300 hover:text-gray-700'
                        "
                    >
                        {{ item.icon }} {{ item.name }}
                    </router-link>
                </div>
                <div class="pt-4 pb-3 border-t border-gray-200">
                    <div class="flex items-center px-4">
                        <div class="text-base font-medium text-gray-800">
                            {{ user.name }}
                        </div>
                    </div>
                    <div class="mt-3 space-y-1">
                        <button
                            @click="logout"
                            class="block w-full text-left px-4 py-2 text-base font-medium text-red-600 hover:bg-gray-100"
                        >
                            Logout
                        </button>
                    </div>
                </div>
            </div>
        </nav>

        <!-- Page Content -->
        <main class="py-10">
            <div class="max-w-7xl mx-auto sm:px-6 lg:px-8">
                <slot />
            </div>
        </main>
    </div>
</template>

<style scoped>
@keyframes ring {
    0% {
        transform: rotate(0deg);
    }
    15% {
        transform: rotate(15deg);
    }
    30% {
        transform: rotate(-15deg);
    }
    45% {
        transform: rotate(10deg);
    }
    60% {
        transform: rotate(-10deg);
    }
    75% {
        transform: rotate(5deg);
    }
    100% {
        transform: rotate(0deg);
    }
}

.animate-ring {
    display: inline-block;
    animation: ring 600ms cubic-bezier(0.36, 0.07, 0.19, 0.97);
}
</style>
<script setup>
import { ref, onMounted } from "vue";
import 'chart.js/auto';
import { Line } from "vue-chartjs";
import AppLayout from "@/components/AppLayout.vue";
import api from "@/utils/api";

const todaySummary = ref(null);
const monthlyData = ref(null);
const loading = ref(true);
const error = ref(null);

const chartData = ref({
    labels: [],
    datasets: [
        {
            label: "Present",
            backgroundColor: "#10b981",
            borderColor: "#10b981",
            data: [],
        },
        {
            label: "Absent",
            backgroundColor: "#ef4444",
            borderColor: "#ef4444",
            data: [],
        },
        {
            label: "Late",
            backgroundColor: "#f59e0b",
            borderColor: "#f59e0b",
            data: [],
        },
    ],
});

const chartOptions = {
    responsive: true,
    maintainAspectRatio: false,
    plugins: {
        legend: {
            position: "top",
        },
        title: {
            display: true,
            text: "Monthly Attendance Overview",
        },
    },
};

async function loadTodaySummary() {
    try {
        const res = await api.get("/attendance/today-summary");
        todaySummary.value = res.data;
    } catch (err) {
        console.error("Failed to load today summary:", err);
        error.value = "Failed to load attendance summary";
    }
}

async function loadMonthlyReport() {
    try {
        const today = new Date();
        const month = String(today.getMonth() + 1).padStart(2, "0");
        const year = today.getFullYear();

        const res = await api.get("/attendance/monthly-report", {
            params: {
                month: `${year}-${month}`,
                class: "8", // or make this dynamic
            },
        });

        monthlyData.value = res.data;

        // Process data for chart
        if (res.data && res.data.daily_stats) {
            const stats = res.data.daily_stats;
            chartData.value.labels = Object.keys(stats);
            chartData.value.datasets[0].data = Object.values(stats).map(
                (d) => d.present || 0
            );
            chartData.value.datasets[1].data = Object.values(stats).map(
                (d) => d.absent || 0
            );
            chartData.value.datasets[2].data = Object.values(stats).map(
                (d) => d.late || 0
            );
        }
    } catch (err) {
        console.error("Failed to load monthly report:", err);
    }
}

onMounted(async () => {
    loading.value = true;
    await Promise.all([loadTodaySummary(), loadMonthlyReport()]);
    loading.value = false;
});
</script>

<template>
    <AppLayout>
        <div class="space-y-6">
            <!-- Header -->
            <div class="bg-white shadow rounded-lg p-6">
                <h1 class="text-2xl font-bold text-gray-900">Dashboard</h1>
                <p class="mt-1 text-sm text-gray-600">
                    Today's attendance overview
                </p>
            </div>

            <!-- Loading State -->
            <div
                v-if="loading"
                class="bg-white shadow rounded-lg p-12 text-center"
            >
                <div
                    class="animate-spin rounded-full h-12 w-12 border-b-2 border-blue-600 mx-auto"
                ></div>
                <p class="mt-4 text-gray-600">Loading dashboard...</p>
            </div>

            <!-- Error State -->
            <div
                v-else-if="error"
                class="bg-red-50 border border-red-200 rounded-lg p-4"
            >
                <p class="text-red-800">{{ error }}</p>
            </div>

            <!-- Dashboard Content -->
            <template v-else>
                <!-- Today's Summary Stats -->
                <div
                    class="grid grid-cols-1 gap-5 sm:grid-cols-2 lg:grid-cols-4"
                >
                    <div class="bg-white overflow-hidden shadow rounded-lg">
                        <div class="p-5">
                            <div class="flex items-center">
                                <div class="flex-shrink-0">
                                    <span class="text-3xl">✓</span>
                                </div>
                                <div class="ml-5 w-0 flex-1">
                                    <dl>
                                        <dt
                                            class="text-sm font-medium text-gray-500 truncate"
                                        >
                                            Total Present
                                        </dt>
                                        <dd
                                            class="text-3xl font-semibold text-green-600"
                                        >
                                            {{ todaySummary?.present || 0 }}
                                        </dd>
                                    </dl>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="bg-white overflow-hidden shadow rounded-lg">
                        <div class="p-5">
                            <div class="flex items-center">
                                <div class="flex-shrink-0">
                                    <span class="text-3xl">✗</span>
                                </div>
                                <div class="ml-5 w-0 flex-1">
                                    <dl>
                                        <dt
                                            class="text-sm font-medium text-gray-500 truncate"
                                        >
                                            Total Absent
                                        </dt>
                                        <dd
                                            class="text-3xl font-semibold text-red-600"
                                        >
                                            {{ todaySummary?.absent || 0 }}
                                        </dd>
                                    </dl>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="bg-white overflow-hidden shadow rounded-lg">
                        <div class="p-5">
                            <div class="flex items-center">
                                <div class="flex-shrink-0">
                                    <span class="text-3xl">⏰</span>
                                </div>
                                <div class="ml-5 w-0 flex-1">
                                    <dl>
                                        <dt
                                            class="text-sm font-medium text-gray-500 truncate"
                                        >
                                            Late
                                        </dt>
                                        <dd
                                            class="text-3xl font-semibold text-yellow-600"
                                        >
                                            {{ todaySummary?.late || 0 }}
                                        </dd>
                                    </dl>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="bg-white overflow-hidden shadow rounded-lg">
                        <div class="p-5">
                            <div class="flex items-center">
                                <div class="flex-shrink-0">
                                    <span class="text-3xl">📊</span>
                                </div>
                                <div class="ml-5 w-0 flex-1">
                                    <dl>
                                        <dt
                                            class="text-sm font-medium text-gray-500 truncate"
                                        >
                                            Attendance Rate
                                        </dt>
                                        <dd
                                            class="text-3xl font-semibold text-blue-600"
                                        >
                                            {{ todaySummary?.percentage || 0 }}%
                                        </dd>
                                    </dl>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Monthly Chart -->
                <div class="bg-white shadow rounded-lg p-6">
                    <h2 class="text-lg font-medium text-gray-900 mb-4">
                        Monthly Attendance Trend
                    </h2>
                    <div class="h-96">
                        <Line :data="chartData" :options="chartOptions" />
                    </div>
                </div>

                <!-- Quick Actions -->
                <div class="bg-white shadow rounded-lg p-6">
                    <h2 class="text-lg font-medium text-gray-900 mb-4">
                        Quick Actions
                    </h2>
                    <div class="grid grid-cols-1 gap-4 sm:grid-cols-3">
                        <router-link
                            to="/attendance"
                            class="flex items-center justify-center px-4 py-3 border border-transparent text-sm font-medium rounded-md text-white bg-blue-600 hover:bg-blue-700"
                        >
                            Record Attendance
                        </router-link>
                        <router-link
                            to="/students"
                            class="flex items-center justify-center px-4 py-3 border border-gray-300 text-sm font-medium rounded-md text-gray-700 bg-white hover:bg-gray-50"
                        >
                            View Students
                        </router-link>
                        <button
                            @click="loadTodaySummary"
                            class="flex items-center justify-center px-4 py-3 border border-gray-300 text-sm font-medium rounded-md text-gray-700 bg-white hover:bg-gray-50"
                        >
                            Refresh Data
                        </button>
                    </div>
                </div>
            </template>
        </div>
    </AppLayout>
</template>

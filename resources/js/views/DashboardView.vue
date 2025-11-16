<script setup>
import { ref, onMounted } from "vue";
import "chart.js/auto";
import { useToast } from "vue-toastification";
import { Line } from "vue-chartjs";
import AppLayout from "@/Components/AppLayout.vue";
import api from "@/utils/api";

const selectedClass = ref("");
const todaySummary = ref(null);
const monthlyData = ref(null);
const loading = ref(true);
const error = ref(null);
const toast = useToast();
const generatingReport = ref(false);
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

async function generateReport() {
    try {
        generatingReport.value = true;
        toast.info("Generating report...");

        // month and class can be passed dynamically — currently uses this month and all classes
        const today = new Date();
        const month = `${today.getFullYear()}-${String(
            today.getMonth() + 1
        ).padStart(2, "0")}`;

        const res = await api.get("/attendance/generate-report", {
            params: {
                month, // or pass some selected month/class from UI
                // class: "8"
            },
            responseType: "blob",
        });

        // get filename from header (if provided)
        const disposition =
            res.headers["content-disposition"] ||
            res.headers["Content-Disposition"];
        let filename = `attendance_${month}.zip`;
        if (disposition) {
            const match = /filename="?(.+)"?/.exec(disposition);
            if (match && match[1]) filename = match[1];
        }

        const url = window.URL.createObjectURL(
            new Blob([res.data], { type: res.data.type || "application/zip" })
        );
        const link = document.createElement("a");
        link.href = url;
        link.setAttribute("download", filename);
        document.body.appendChild(link);
        link.click();
        link.remove();
        window.URL.revokeObjectURL(url);

        toast.success("Report ready — download started.");
    } catch (err) {
        console.error("Generate report error:", err);
        toast.error("Failed to generate report");
    } finally {
        generatingReport.value = false;
    }
}

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

        const params = { month: `${year}-${month}` };
        if (selectedClass.value) params.class = selectedClass.value;

        const res = await api.get("/attendance/monthly-report", { params });

        console.log("monthly-report response", res.data);

        const data = res.data || {};
        const stats = data.daily_stats || {};

        const entries = Object.entries(stats);
        if (entries.length === 0) {
            // Reset chart to empty
            chartData.value = {
                labels: [],
                datasets: chartData.value.datasets.map((ds) => ({
                    ...ds,
                    data: [],
                })),
            };
            return;
        }

        entries.sort((a, b) => new Date(a[0]) - new Date(b[0]));

        const labels = entries.map((e) => e[0]);
        const presentArr = entries.map((e) => Number(e[1]?.present ?? 0));
        const absentArr = entries.map((e) => Number(e[1]?.absent ?? 0));
        const lateArr = entries.map((e) => Number(e[1]?.late ?? 0));

        const maxVal = Math.max(...presentArr, ...absentArr, ...lateArr, 1);

        // Replace chartData entirely (triggers reactive update)
        chartData.value = {
            labels,
            datasets: [
                {
                    label: "Present",
                    backgroundColor: "#10b981",
                    borderColor: "#10b981",
                    data: presentArr,
                },
                {
                    label: "Absent",
                    backgroundColor: "#ef4444",
                    borderColor: "#ef4444",
                    data: absentArr,
                },
                {
                    label: "Late",
                    backgroundColor: "#f59e0b",
                    borderColor: "#f59e0b",
                    data: lateArr,
                },
            ],
        };

        // Ensure y-axis has a reasonable scale so 0/1 values don't compress the plot
        chartOptions.scales = {
            y: {
                beginAtZero: true,
                suggestedMax: Math.ceil(maxVal * 1.2),
                ticks: {
                    stepSize: Math.max(1, Math.ceil(maxVal / 5)),
                },
            },
        };
    } catch (err) {
        console.error(
            "Failed to load monthly report:",
            err,
            err.response?.data || ""
        );
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
                <div class="space-y-6">
                    <h2 class="text-lg font-medium text-gray-900">
                        Today's Summary
                    </h2>
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
                                                {{
                                                    todaySummary?.percentage ||
                                                    0
                                                }}%
                                            </dd>
                                        </dl>
                                    </div>
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
                    <div class="flex items-center space-x-2">
                        <select
                            v-model="selectedClass"
                            @change="loadMonthlyReport"
                            class="px-3 py-1 border rounded bg-blue-600 text-white hover:bg-blue-700 focus:outline-none"
                        >
                            <option value="">All Classes</option>
                            <option value="6">Class 6</option>
                            <option value="7">Class 7</option>
                            <option value="8">Class 8</option>
                            <option value="9">Class 9</option>
                            <option value="10">Class 10</option>
                        </select>
                    </div>
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
                        <button
                            @click="
                                $router.push({
                                    name: 'reports',
                                    query: {
                                        month: new Date()
                                            .toISOString()
                                            .slice(0, 7),
                                    },
                                })
                            "
                            class="px-4 py-2 bg-indigo-600 text-white rounded hover:bg-indigo-700"
                        >
                            Generate / Preview Monthly Report
                        </button>
                    </div>
                </div>
            </template>
        </div>
    </AppLayout>
</template>

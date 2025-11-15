<script setup>
import { ref, onMounted, computed } from "vue";
import { useRoute, useRouter } from "vue-router";
import AppLayout from "@/components/AppLayout.vue";
import api from "@/utils/api";
import { useToast } from "vue-toastification";

const toast = useToast();
const route = useRoute();
const router = useRouter();

const month = ref(route.query.month || new Date().toISOString().slice(0, 7));
const classFilter = ref(route.query.class || "");
const type = ref(route.query.type || "summary");

const loading = ref(false);
const rows = ref([]);
const error = ref(null);
const classes = ref([]);
const loadingClasses = ref(false);

// Sorting
const sortColumn = ref(null);
const sortDirection = ref("asc");

// Search
const searchQuery = ref("");

// Fetch available classes
async function fetchClasses() {
    loadingClasses.value = true;
    try {
        // Adjust endpoint to match your API
        const res = await api.get("/students/classes");
        classes.value = res.data || [];
    } catch (err) {
        console.error("Failed to fetch classes", err);
        // Fallback to common classes if API fails
        classes.value = ["6", "7", "8", "9", "10"];
    } finally {
        loadingClasses.value = false;
    }
}

async function fetchPreview() {
    loading.value = true;
    error.value = null;
    try {
        const res = await api.get("/attendance/report", {
            params: {
                month: month.value,
                class: classFilter.value || undefined,
                type: type.value,
                format: "json",
            },
        });
        rows.value = res.data.rows || [];
    } catch (err) {
        console.error("Fetch preview error", err);
        error.value = err.response?.data?.message || "Failed to fetch report";
        rows.value = [];
    } finally {
        loading.value = false;
    }
}

// Computed statistics for summary view
const statistics = computed(() => {
    if (type.value !== "summary" || !rows.value.length) return null;

    const totalStudents = rows.value.length;
    const totalPresent = rows.value.reduce(
        (sum, r) => sum + (r.present_count || 0),
        0
    );
    const totalAbsent = rows.value.reduce(
        (sum, r) => sum + (r.absent_count || 0),
        0
    );
    const totalLate = rows.value.reduce(
        (sum, r) => sum + (r.late_count || 0),
        0
    );
    const totalRecords = totalPresent + totalAbsent + totalLate;
    const attendanceRate =
        totalRecords > 0 ? ((totalPresent / totalRecords) * 100).toFixed(1) : 0;

    return {
        totalStudents,
        totalPresent,
        totalAbsent,
        totalLate,
        attendanceRate,
    };
});

// Filtered and sorted rows
const filteredRows = computed(() => {
    let filtered = [...rows.value];

    // Apply search filter
    if (searchQuery.value) {
        const query = searchQuery.value.toLowerCase();
        filtered = filtered.filter((r) => {
            if (type.value === "summary") {
                return (
                    r.student_name?.toLowerCase().includes(query) ||
                    r.student_id?.toString().includes(query) ||
                    r.class?.toString().includes(query)
                );
            } else {
                return (
                    r.student_name?.toLowerCase().includes(query) ||
                    r.student_id?.toString().includes(query) ||
                    r.status?.toLowerCase().includes(query) ||
                    r.date?.includes(query)
                );
            }
        });
    }

    // Apply sorting
    if (sortColumn.value) {
        filtered.sort((a, b) => {
            let aVal = a[sortColumn.value];
            let bVal = b[sortColumn.value];

            // Handle numeric values
            if (typeof aVal === "number" && typeof bVal === "number") {
                return sortDirection.value === "asc"
                    ? aVal - bVal
                    : bVal - aVal;
            }

            // Handle string values
            aVal = String(aVal || "").toLowerCase();
            bVal = String(bVal || "").toLowerCase();

            if (sortDirection.value === "asc") {
                return aVal < bVal ? -1 : aVal > bVal ? 1 : 0;
            } else {
                return aVal > bVal ? -1 : aVal < bVal ? 1 : 0;
            }
        });
    }

    return filtered;
});

function sortBy(column) {
    if (sortColumn.value === column) {
        sortDirection.value = sortDirection.value === "asc" ? "desc" : "asc";
    } else {
        sortColumn.value = column;
        sortDirection.value = "asc";
    }
}

function getStatusBadgeClass(status) {
    const statusMap = {
        present: "bg-green-100 text-green-800",
        absent: "bg-red-100 text-red-800",
        late: "bg-yellow-100 text-yellow-800",
        excused: "bg-blue-100 text-blue-800",
    };
    return statusMap[status?.toLowerCase()] || "bg-gray-100 text-gray-800";
}

function downloadCsv() {
    const params = new URLSearchParams({
        month: month.value,
        type: type.value,
        format: "csv",
    });
    if (classFilter.value) params.set("class", classFilter.value);

    const token = localStorage.getItem("api_token");
    const url = `/api/attendance/report?${params.toString()}`;
    const bearer = token ? `Bearer ${token}` : null;

    fetch(url, {
        method: "GET",
        headers: bearer ? { Authorization: bearer } : {},
    })
        .then(async (res) => {
            if (!res.ok) {
                const txt = await res.text();
                throw new Error(txt || "Failed to download");
            }
            const blob = await res.blob();
            let filename = `report_${month.value}_${type.value}.csv`;
            const disp = res.headers.get("content-disposition");
            if (disp) {
                const m = /filename="?(.+)"?/.exec(disp);
                if (m && m[1]) filename = m[1];
            }
            const blobUrl = window.URL.createObjectURL(blob);
            const a = document.createElement("a");
            a.href = blobUrl;
            a.download = filename;
            document.body.appendChild(a);
            a.click();
            a.remove();
            window.URL.revokeObjectURL(blobUrl);
            toast.success("Download started");
        })
        .catch((err) => {
            console.error(err);
            toast.error("Failed to download CSV");
        });
}

onMounted(() => {
    fetchClasses();
    fetchPreview();
});
</script>

<template>
    <AppLayout>
        <div class="space-y-6 max-w-7xl mx-auto px-4">
            <!-- Header -->
            <div class="bg-white p-6 rounded-lg shadow">
                <div class="flex items-center justify-between mb-6">
                    <h2 class="text-2xl font-bold text-gray-900">
                        Attendance Reports
                    </h2>
                    <button
                        class="px-4 py-2 text-gray-700 hover:bg-gray-50 rounded-lg border"
                        @click="$router.push('/dashboard')"
                    >
                        ← Back to Dashboard
                    </button>
                </div>

                <!-- Filters -->
                <div class="grid grid-cols-1 md:grid-cols-4 gap-4 mb-4">
                    <div>
                        <label
                            class="block text-sm font-medium text-gray-700 mb-1"
                        >
                            Month
                        </label>
                        <input
                            type="month"
                            v-model="month"
                            class="w-full border border-gray-300 rounded-lg px-3 py-2 focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                        />
                    </div>

                    <div>
                        <label
                            class="block text-sm font-medium text-gray-700 mb-1"
                        >
                            Class
                        </label>
                        <select
                            v-model="classFilter"
                            class="w-full border border-gray-300 rounded-lg px-3 py-2 focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                            :disabled="loadingClasses"
                        >
                            <option value="">All Classes</option>
                            <option
                                v-for="cls in classes"
                                :key="cls"
                                :value="cls"
                            >
                                Class {{ cls }}
                            </option>
                        </select>
                    </div>

                    <div>
                        <label
                            class="block text-sm font-medium text-gray-700 mb-1"
                        >
                            Report Type
                        </label>
                        <select
                            v-model="type"
                            class="w-full border border-gray-300 rounded-lg px-3 py-2 focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                        >
                            <option value="summary">
                                Summary (per student)
                            </option>
                            <option value="detailed">
                                Detailed (daily records)
                            </option>
                        </select>
                    </div>

                    <div class="flex items-end">
                        <button
                            class="w-full px-4 py-2 bg-blue-600 hover:bg-blue-700 text-white rounded-lg font-medium transition"
                            @click="fetchPreview"
                            :disabled="loading"
                        >
                            {{ loading ? "Loading..." : "Generate Report" }}
                        </button>
                    </div>
                </div>

                <!-- Action Buttons -->
                <div class="flex flex-wrap gap-2">
                    <button
                        class="px-4 py-2 bg-green-600 hover:bg-green-700 text-white rounded-lg font-medium transition"
                        @click="downloadCsv"
                        :disabled="loading || !rows.length"
                    >
                        📥 Download CSV
                    </button>
                    <div class="flex-1"></div>
                    <input
                        v-model="searchQuery"
                        type="text"
                        placeholder="Search..."
                        class="px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                    />
                </div>
            </div>

            <!-- Statistics Cards (Summary View Only) -->
            <div
                v-if="statistics && !loading"
                class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-5 gap-4"
            >
                <div class="bg-white p-4 rounded-lg shadow">
                    <div class="text-sm text-gray-600">Total Students</div>
                    <div class="text-2xl font-bold text-gray-900">
                        {{ statistics.totalStudents }}
                    </div>
                </div>
                <div class="bg-white p-4 rounded-lg shadow">
                    <div class="text-sm text-gray-600">Attendance Rate</div>
                    <div class="text-2xl font-bold text-green-600">
                        {{ statistics.attendanceRate }}%
                    </div>
                </div>
                <div class="bg-white p-4 rounded-lg shadow">
                    <div class="text-sm text-gray-600">Total Present</div>
                    <div class="text-2xl font-bold text-green-600">
                        {{ statistics.totalPresent }}
                    </div>
                </div>
                <div class="bg-white p-4 rounded-lg shadow">
                    <div class="text-sm text-gray-600">Total Absent</div>
                    <div class="text-2xl font-bold text-red-600">
                        {{ statistics.totalAbsent }}
                    </div>
                </div>
                <div class="bg-white p-4 rounded-lg shadow">
                    <div class="text-sm text-gray-600">Total Late</div>
                    <div class="text-2xl font-bold text-yellow-600">
                        {{ statistics.totalLate }}
                    </div>
                </div>
            </div>

            <!-- Results -->
            <div class="bg-white rounded-lg shadow overflow-hidden">
                <!-- Loading State -->
                <div v-if="loading" class="p-12 text-center">
                    <div
                        class="inline-block animate-spin rounded-full h-12 w-12 border-4 border-gray-200 border-t-blue-600"
                    ></div>
                    <p class="mt-4 text-gray-600">Loading report data...</p>
                </div>

                <!-- Error State -->
                <div v-else-if="error" class="p-8">
                    <div class="bg-red-50 border border-red-200 rounded-lg p-4">
                        <div class="flex items-start">
                            <span class="text-red-600 text-xl mr-3">⚠️</span>
                            <div class="flex-1">
                                <h3 class="font-semibold text-red-900">
                                    Error Loading Report
                                </h3>
                                <p class="text-red-700 mt-1">{{ error }}</p>
                                <button
                                    @click="fetchPreview"
                                    class="mt-3 px-4 py-2 bg-red-100 hover:bg-red-200 text-red-800 rounded-lg text-sm font-medium transition"
                                >
                                    Try Again
                                </button>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Empty State -->
                <div v-else-if="!filteredRows.length" class="p-12 text-center">
                    <div class="text-6xl mb-4">📊</div>
                    <h3 class="text-xl font-semibold text-gray-900 mb-2">
                        No Data Found
                    </h3>
                    <p class="text-gray-600">
                        No attendance records found for the selected filters.
                    </p>
                </div>

                <!-- Summary Table -->
                <div v-else-if="type === 'summary'" class="overflow-x-auto">
                    <table class="min-w-full divide-y divide-gray-200">
                        <thead class="bg-gray-50">
                            <tr>
                                <th
                                    @click="sortBy('student_id')"
                                    class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider cursor-pointer hover:bg-gray-100"
                                >
                                    Student ID
                                    <span v-if="sortColumn === 'student_id'">
                                        {{
                                            sortDirection === "asc" ? "↑" : "↓"
                                        }}
                                    </span>
                                </th>
                                <th
                                    @click="sortBy('student_name')"
                                    class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider cursor-pointer hover:bg-gray-100"
                                >
                                    Name
                                    <span v-if="sortColumn === 'student_name'">
                                        {{
                                            sortDirection === "asc" ? "↑" : "↓"
                                        }}
                                    </span>
                                </th>
                                <th
                                    @click="sortBy('class')"
                                    class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider cursor-pointer hover:bg-gray-100"
                                >
                                    Class
                                    <span v-if="sortColumn === 'class'">
                                        {{
                                            sortDirection === "asc" ? "↑" : "↓"
                                        }}
                                    </span>
                                </th>
                                <th
                                    @click="sortBy('present_count')"
                                    class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider cursor-pointer hover:bg-gray-100"
                                >
                                    Present
                                    <span v-if="sortColumn === 'present_count'">
                                        {{
                                            sortDirection === "asc" ? "↑" : "↓"
                                        }}
                                    </span>
                                </th>
                                <th
                                    @click="sortBy('absent_count')"
                                    class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider cursor-pointer hover:bg-gray-100"
                                >
                                    Absent
                                    <span v-if="sortColumn === 'absent_count'">
                                        {{
                                            sortDirection === "asc" ? "↑" : "↓"
                                        }}
                                    </span>
                                </th>
                                <th
                                    @click="sortBy('late_count')"
                                    class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider cursor-pointer hover:bg-gray-100"
                                >
                                    Late
                                    <span v-if="sortColumn === 'late_count'">
                                        {{
                                            sortDirection === "asc" ? "↑" : "↓"
                                        }}
                                    </span>
                                </th>
                            </tr>
                        </thead>
                        <tbody class="bg-white divide-y divide-gray-200">
                            <tr
                                v-for="r in filteredRows"
                                :key="r.student_id"
                                class="hover:bg-gray-50 transition"
                            >
                                <td
                                    class="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900"
                                >
                                    {{ r.student_id }}
                                </td>
                                <td
                                    class="px-6 py-4 whitespace-nowrap text-sm text-gray-900"
                                >
                                    {{ r.student_name }}
                                </td>
                                <td
                                    class="px-6 py-4 whitespace-nowrap text-sm text-gray-600"
                                >
                                    {{ r.class }}
                                </td>
                                <td class="px-6 py-4 whitespace-nowrap">
                                    <span
                                        class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-green-100 text-green-800"
                                    >
                                        {{ r.present_count }}
                                    </span>
                                </td>
                                <td class="px-6 py-4 whitespace-nowrap">
                                    <span
                                        class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-red-100 text-red-800"
                                    >
                                        {{ r.absent_count }}
                                    </span>
                                </td>
                                <td class="px-6 py-4 whitespace-nowrap">
                                    <span
                                        class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-yellow-100 text-yellow-800"
                                    >
                                        {{ r.late_count }}
                                    </span>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>

                <!-- Detailed Table -->
                <div v-else class="overflow-x-auto">
                    <table class="min-w-full divide-y divide-gray-200">
                        <thead class="bg-gray-50">
                            <tr>
                                <th
                                    @click="sortBy('date')"
                                    class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider cursor-pointer hover:bg-gray-100"
                                >
                                    Date
                                    <span v-if="sortColumn === 'date'">
                                        {{
                                            sortDirection === "asc" ? "↑" : "↓"
                                        }}
                                    </span>
                                </th>
                                <th
                                    @click="sortBy('student_name')"
                                    class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider cursor-pointer hover:bg-gray-100"
                                >
                                    Student
                                    <span v-if="sortColumn === 'student_name'">
                                        {{
                                            sortDirection === "asc" ? "↑" : "↓"
                                        }}
                                    </span>
                                </th>
                                <th
                                    @click="sortBy('class')"
                                    class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider cursor-pointer hover:bg-gray-100"
                                >
                                    Class
                                    <span v-if="sortColumn === 'class'">
                                        {{
                                            sortDirection === "asc" ? "↑" : "↓"
                                        }}
                                    </span>
                                </th>
                                <th
                                    @click="sortBy('status')"
                                    class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider cursor-pointer hover:bg-gray-100"
                                >
                                    Status
                                    <span v-if="sortColumn === 'status'">
                                        {{
                                            sortDirection === "asc" ? "↑" : "↓"
                                        }}
                                    </span>
                                </th>
                                <th
                                    class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider"
                                >
                                    Note
                                </th>
                            </tr>
                        </thead>
                        <tbody class="bg-white divide-y divide-gray-200">
                            <tr
                                v-for="(r, idx) in filteredRows"
                                :key="idx"
                                class="hover:bg-gray-50 transition"
                            >
                                <td
                                    class="px-6 py-4 whitespace-nowrap text-sm text-gray-900"
                                >
                                    {{ r.date }}
                                </td>
                                <td
                                    class="px-6 py-4 whitespace-nowrap text-sm text-gray-900"
                                >
                                    {{ r.student_name }}
                                    <span class="text-gray-500 text-xs block"
                                        >ID: {{ r.student_id }}</span
                                    >
                                </td>
                                <td
                                    class="px-6 py-4 whitespace-nowrap text-sm text-gray-600"
                                >
                                    {{ r.class }}
                                </td>
                                <td class="px-6 py-4 whitespace-nowrap">
                                    <span
                                        :class="[
                                            'inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium capitalize',
                                            getStatusBadgeClass(r.status),
                                        ]"
                                    >
                                        {{ r.status }}
                                    </span>
                                </td>
                                <td class="px-6 py-4 text-sm text-gray-600">
                                    {{ r.note || "-" }}
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>

                <!-- Results Count -->
                <div
                    v-if="!loading && !error && filteredRows.length"
                    class="px-6 py-3 bg-gray-50 border-t border-gray-200"
                >
                    <p class="text-sm text-gray-600">
                        Showing {{ filteredRows.length }}
                        {{ filteredRows.length === 1 ? "record" : "records" }}
                        <span v-if="searchQuery">
                            (filtered from {{ rows.length }} total)</span
                        >
                    </p>
                </div>
            </div>
        </div>
    </AppLayout>
</template>

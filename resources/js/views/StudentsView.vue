<script setup>
import { ref, onMounted } from "vue";
import { useRouter } from "vue-router";
import AppLayout from "@/components/AppLayout.vue";
import api from "@/utils/api";
import Swal from "sweetalert2";
import { useToast } from "vue-toastification";

const toast = useToast();
const router = useRouter();

const students = ref([]);
const meta = ref(null);
const loading = ref(false);
const error = ref(null);

const filters = ref({
    search: "",
    class: "",
    section: "",
});

async function loadStudents(page = 1) {
    loading.value = true;
    error.value = null;

    try {
        const params = { page };

        if (filters.value.search) params.search = filters.value.search;
        if (filters.value.class) params.class = filters.value.class;
        if (filters.value.section) params.section = filters.value.section;

        const res = await api.get("/students", { params });

        students.value = res.data.data || res.data;
        meta.value = res.data.meta || null;
    } catch (err) {
        error.value = err.response?.data?.message || "Failed to load students";
        console.error("Load students error:", err);
    } finally {
        loading.value = false;
    }
}

function handleSearch() {
    loadStudents(1);
}

function clearFilters() {
    filters.value = { search: "", class: "", section: "" };
    loadStudents(1);
}

function goToCreate() {
    router.push("/students/create");
}

function goToEdit(id) {
    router.push(`/students/${id}/edit`);
}

async function deleteStudent(id) {
    const result = await Swal.fire({
        title: "Delete student?",
        text: "This action cannot be undone.",
        icon: "warning",
        showCancelButton: true,
        confirmButtonText: "Yes, delete",
        cancelButtonText: "Cancel",
        confirmButtonColor: "#dc2626",
    });

    if (!result.isConfirmed) return;

    try {
        await api.delete(`/students/${id}`);

        // optimistic UI: remove the student from the array so page updates instantly
        students.value = students.value.filter((s) => s.id !== id);

        // update pagination total if present
        if (meta.value && typeof meta.value.total === "number") {
            meta.value.total = Math.max(0, meta.value.total - 1);
        }

        toast.success("Student deleted");
    } catch (err) {
        console.error("Delete student error:", err);
        const msg = err.response?.data?.message || "Delete failed";
        toast.error(msg);
        Swal.fire("Error", msg, "error");
    }
}

onMounted(() => loadStudents());
</script>

<template>
    <AppLayout>
        <div class="space-y-6">
            <!-- Header -->
            <div class="bg-white shadow rounded-lg p-6">
                <div class="flex items-center justify-between">
                    <div>
                        <h1 class="text-2xl font-bold text-gray-900">
                            Students
                        </h1>
                        <p class="mt-1 text-sm text-gray-600">
                            Manage student records
                        </p>
                    </div>
                    <button
                        @click="goToCreate"
                        class="px-4 py-2 bg-blue-600 text-white rounded-md hover:bg-blue-700"
                    >
                        + Add Student
                    </button>
                </div>
            </div>

            <!-- Filters -->
            <div class="bg-white shadow rounded-lg p-6">
                <div class="grid grid-cols-1 gap-4 sm:grid-cols-4">
                    <div>
                        <label
                            class="block text-sm font-medium text-gray-700 mb-1"
                            >Search</label
                        >
                        <input
                            v-model="filters.search"
                            type="text"
                            placeholder="Search by name or ID..."
                            class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-blue-500 focus:border-blue-500"
                            @keyup.enter="handleSearch"
                        />
                    </div>
                    <div>
                        <label
                            class="block text-sm font-medium text-gray-700 mb-1"
                            >Class</label
                        >
                        <select
                            v-model="filters.class"
                            class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-blue-500 focus:border-blue-500 "
                        >
                            <option value="">All Classes</option>
                            <option value="6">Class 6</option>
                            <option value="7">Class 7</option>
                            <option value="8">Class 8</option>
                            <option value="9">Class 9</option>
                            <option value="10">Class 10</option>
                        </select>
                    </div>
                    <div>
                        <label
                            class="block text-sm font-medium text-gray-700 mb-1"
                            >Section</label
                        >
                        <select
                            v-model="filters.section"
                            class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-blue-500 focus:border-blue-500"
                        >
                            <option value="">All Sections</option>
                            <option value="A">Section A</option>
                            <option value="B">Section B</option>
                            <option value="C">Section C</option>
                        </select>
                    </div>
                    <div class="flex items-end space-x-2">
                        <button
                            @click="handleSearch"
                            class="flex-1 px-4 py-2 bg-blue-600 text-white rounded-md hover:bg-blue-700"
                        >
                            Search
                        </button>
                        <button
                            @click="clearFilters"
                            class="px-4 py-2 border border-gray-300 text-gray-700 rounded-md hover:bg-gray-50"
                        >
                            Clear
                        </button>
                    </div>
                </div>
            </div>

            <!-- Loading State -->
            <div
                v-if="loading"
                class="bg-white shadow rounded-lg p-12 text-center"
            >
                <div
                    class="animate-spin rounded-full h-12 w-12 border-b-2 border-blue-600 mx-auto"
                ></div>
                <p class="mt-4 text-gray-600">Loading students...</p>
            </div>

            <!-- Error State -->
            <div
                v-else-if="error"
                class="bg-red-50 border border-red-200 rounded-lg p-4"
            >
                <p class="text-red-800">{{ error }}</p>
            </div>

            <!-- Students Table -->
            <div v-else class="bg-white shadow rounded-lg overflow-hidden">
                <table class="min-w-full divide-y divide-gray-200">
                    <thead class="bg-gray-50">
                        <tr>
                            <th
                                class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider"
                            >
                                Student ID
                            </th>
                            <th
                                class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider"
                            >
                                Name
                            </th>
                            <th
                                class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider"
                            >
                                Class
                            </th>
                            <th
                                class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider"
                            >
                                Section
                            </th>
                            <th
                                class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider"
                            >
                                Actions
                            </th>
                        </tr>
                    </thead>
                    <tbody class="bg-white divide-y divide-gray-200">
                        <tr v-if="students.length === 0">
                            <td
                                colspan="5"
                                class="px-6 py-4 text-center text-gray-500"
                            >
                                No students found
                            </td>
                        </tr>

                        <tr
                            v-for="student in students"
                            :key="student.id"
                            class="hover:bg-gray-50"
                        >
                            <td
                                class="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900"
                            >
                                {{ student.student_id }}
                            </td>

                            <!-- Name with avatar -->
                            <td class="px-6 py-4 whitespace-nowrap">
                                <div class="flex items-center">
                                    <div class="h-10 w-10 flex-shrink-0">
                                        <!-- If student.photo is provided (StudentResource returns full URL), show it -->
                                        <img
                                            v-if="student.photo"
                                            :src="student.photo"
                                            alt="avatar"
                                            class="h-10 w-10 rounded-full object-cover border"
                                        />
                                        <!-- Fallback initials -->
                                        <div
                                            v-else
                                            class="h-10 w-10 rounded-full bg-blue-100 flex items-center justify-center"
                                        >
                                            <span
                                                class="text-blue-600 font-medium"
                                            >
                                                {{
                                                    (student.name || "").charAt(
                                                        0
                                                    )
                                                }}
                                            </span>
                                        </div>
                                    </div>
                                    <div class="ml-4">
                                        <div
                                            class="text-sm font-medium text-gray-900"
                                        >
                                            {{ student.name }}
                                        </div>
                                        <div class="text-xs text-gray-500">
                                            ID: {{ student.student_id }}
                                        </div>
                                    </div>
                                </div>
                            </td>

                            <td
                                class="px-6 py-4 whitespace-nowrap text-sm text-gray-500"
                            >
                                Class {{ student.class }}
                            </td>
                            <td
                                class="px-6 py-4 whitespace-nowrap text-sm text-gray-500"
                            >
                                Section {{ student.section }}
                            </td>

                            <!-- Actions: styled buttons -->
                            <td
                                class="px-6 py-4 whitespace-nowrap text-sm font-medium"
                            >
                                <div class="flex items-center space-x-2">
                                    <button
                                        @click="goToEdit(student.id)"
                                        class="px-3 py-1.5 bg-white border border-gray-300 rounded text-gray-700 hover:bg-gray-50"
                                        aria-label="Edit student"
                                    >
                                        Edit
                                    </button>

                                    <button
                                        @click="deleteStudent(student.id)"
                                        class="px-3 py-1.5 bg-red-600 text-white rounded hover:bg-red-700"
                                        aria-label="Delete student"
                                    >
                                        Delete
                                    </button>
                                </div>
                            </td>
                        </tr>
                    </tbody>
                </table>

                <!-- Pagination -->
                <div
                    v-if="meta"
                    class="bg-white px-4 py-3 flex items-center justify-between border-t border-gray-200 sm:px-6"
                >
                    <div class="flex-1 flex justify-between sm:hidden">
                        <button
                            :disabled="meta.current_page <= 1"
                            @click="loadStudents(meta.current_page - 1)"
                            class="relative inline-flex items-center px-4 py-2 border border-gray-300 text-sm font-medium rounded-md text-gray-700 bg-white hover:bg-gray-50 disabled:opacity-50 disabled:cursor-not-allowed"
                        >
                            Previous
                        </button>
                        <button
                            :disabled="meta.current_page >= meta.last_page"
                            @click="loadStudents(meta.current_page + 1)"
                            class="ml-3 relative inline-flex items-center px-4 py-2 border border-gray-300 text-sm font-medium rounded-md text-gray-700 bg-white hover:bg-gray-50 disabled:opacity-50 disabled:cursor-not-allowed"
                        >
                            Next
                        </button>
                    </div>

                    <div
                        class="hidden sm:flex-1 sm:flex sm:items-center sm:justify-between"
                    >
                        <div>
                            <p class="text-sm text-gray-700">
                                Showing
                                <span class="font-medium">{{
                                    meta.from || 0
                                }}</span>
                                to
                                <span class="font-medium">{{
                                    meta.to || 0
                                }}</span>
                                of
                                <span class="font-medium">{{
                                    meta.total || 0
                                }}</span>
                                results
                            </p>
                        </div>
                        <div>
                            <nav
                                class="relative z-0 inline-flex rounded-md shadow-sm -space-x-px"
                                aria-label="Pagination"
                            >
                                <button
                                    :disabled="meta.current_page <= 1"
                                    @click="loadStudents(meta.current_page - 1)"
                                    class="relative inline-flex items-center px-2 py-2 rounded-l-md border border-gray-300 bg-white text-sm font-medium text-gray-500 hover:bg-gray-50 disabled:opacity-50 disabled:cursor-not-allowed"
                                >
                                    Previous
                                </button>
                                <span
                                    class="relative inline-flex items-center px-4 py-2 border border-gray-300 bg-white text-sm font-medium text-gray-700"
                                >
                                    Page {{ meta.current_page }} of
                                    {{ meta.last_page }}
                                </span>
                                <button
                                    :disabled="
                                        meta.current_page >= meta.last_page
                                    "
                                    @click="loadStudents(meta.current_page + 1)"
                                    class="relative inline-flex items-center px-2 py-2 rounded-r-md border border-gray-300 bg-white text-sm font-medium text-gray-500 hover:bg-gray-50 disabled:opacity-50 disabled:cursor-not-allowed"
                                >
                                    Next
                                </button>
                            </nav>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </AppLayout>
</template>

<script setup>
import { ref, onMounted } from "vue";
import { useRouter, useRoute } from "vue-router";
import AppLayout from "@/components/AppLayout.vue";
import api from "@/utils/api";
import { useToast } from "vue-toastification";

const router = useRouter();
const route = useRoute();
const id = route.params.id;

const toast = useToast();

// keep same lists as Create; consider centralizing later
const classes = ["6", "7", "8", "9", "10"];
const sections = ["A", "B", "C"];

const form = ref({
    name: "",
    student_id: "",
    class: "",
    section: "",
    photo: null, // file to upload
});

const photoUrl = ref(null); // existing photo preview URL from API
const loading = ref(false);
const saving = ref(false);
const error = ref(null);
const fieldErrors = ref({});

function handleFile(e) {
    form.value.photo = e.target.files[0] || null;
}

async function loadStudent() {
    loading.value = true;
    error.value = null;
    fieldErrors.value = {};
    try {
        const res = await api.get(`/students/${id}`);
        const s = res.data.data ?? res.data;
        form.value.name = s.name || "";
        form.value.student_id = s.student_id || "";
        form.value.class = s.class || "";
        form.value.section = s.section || "";
        photoUrl.value = s.photo || null;
    } catch (err) {
        console.error(err);
        error.value = "Failed to load student";
        toast.error("Failed to load student");
    } finally {
        loading.value = false;
    }
}

async function submit() {
    error.value = null;
    fieldErrors.value = {};
    saving.value = true;

    try {
        const fd = new FormData();
        fd.append("name", form.value.name);
        fd.append("student_id", form.value.student_id);
        fd.append("class", form.value.class);
        fd.append("section", form.value.section || "");
        if (form.value.photo) fd.append("photo", form.value.photo);
        fd.append("_method", "PUT");

        await api.post(`/students/${id}`, fd, {
            headers: { "Content-Type": "multipart/form-data" },
        });

        toast.success("Student updated successfully");
        router.push("/students");
    } catch (err) {
        console.error("Update student error:", err);
        const resp = err.response;

        if (resp && resp.status === 422 && resp.data && resp.data.errors) {
            fieldErrors.value = resp.data.errors;
            const firstKey = Object.keys(resp.data.errors)[0];
            toast.error(resp.data.errors[firstKey][0]);
        } else {
            const msg = resp?.data?.message || "Failed to update student.";
            error.value = msg;
            toast.error(msg);
        }
    } finally {
        saving.value = false;
    }
}

onMounted(() => {
    loadStudent();
});
</script>

<template>
    <AppLayout>
        <div class="max-w-3xl mx-auto space-y-6">
            <div class="bg-white p-6 rounded shadow">
                <h2 class="text-xl font-semibold mb-4">Edit Student</h2>

                <div v-if="loading" class="p-6 text-center">Loading…</div>

                <form v-else @submit.prevent="submit" class="space-y-4">
                    <div>
                        <label class="block text-sm font-medium">Name</label>
                        <input
                            v-model="form.name"
                            required
                            class="mt-1 w-full border rounded px-3 py-2"
                        />
                        <div
                            v-if="fieldErrors.name"
                            class="text-sm text-red-600 mt-1"
                        >
                            {{ fieldErrors.name[0] }}
                        </div>
                    </div>

                    <div>
                        <label class="block text-sm font-medium"
                            >Student ID</label
                        >
                        <input
                            v-model="form.student_id"
                            required
                            class="mt-1 w-full border rounded px-3 py-2"
                        />
                        <div
                            v-if="fieldErrors.student_id"
                            class="text-sm text-red-600 mt-1"
                        >
                            {{ fieldErrors.student_id[0] }}
                        </div>
                    </div>

                    <div class="grid grid-cols-2 gap-4">
                        <div>
                            <label class="block text-sm font-medium"
                                >Class</label
                            >
                            <select
                                v-model="form.class"
                                required
                                class="mt-1 w-full border rounded px-3 py-2"
                            >
                                <option value="">Select class</option>
                                <option
                                    v-for="c in classes"
                                    :key="c"
                                    :value="c"
                                >
                                    Class {{ c }}
                                </option>
                            </select>
                            <div
                                v-if="fieldErrors.class"
                                class="text-sm text-red-600 mt-1"
                            >
                                {{ fieldErrors.class[0] }}
                            </div>
                        </div>

                        <div>
                            <label class="block text-sm font-medium"
                                >Section</label
                            >
                            <select
                                v-model="form.section"
                                class="mt-1 w-full border rounded px-3 py-2"
                            >
                                <option value="">Select section</option>
                                <option
                                    v-for="s in sections"
                                    :key="s"
                                    :value="s"
                                >
                                    Section {{ s }}
                                </option>
                            </select>
                            <div
                                v-if="fieldErrors.section"
                                class="text-sm text-red-600 mt-1"
                            >
                                {{ fieldErrors.section[0] }}
                            </div>
                        </div>
                    </div>

                    <div>
                        <label class="block text-sm font-medium"
                            >Current Photo</label
                        >
                        <div
                            v-if="photoUrl"
                            class="mt-2 flex items-center space-x-4"
                        >
                            <img
                                :src="photoUrl"
                                alt="student photo"
                                class="h-20 w-20 rounded object-cover border"
                            />
                            <div class="text-sm text-gray-600">
                                Existing photo (will be replaced if you upload a
                                new one)
                            </div>
                        </div>
                        <div v-else class="mt-2 text-sm text-gray-500">
                            No photo uploaded
                        </div>
                    </div>

                    <div>
                        <label class="block text-sm font-medium"
                            >Photo (new)</label
                        >
                        <input
                            type="file"
                            @change="handleFile"
                            accept="image/*"
                            class="mt-1"
                        />
                        <div
                            v-if="fieldErrors.photo"
                            class="text-sm text-red-600 mt-1"
                        >
                            {{ fieldErrors.photo[0] }}
                        </div>
                    </div>

                    <div class="flex items-center space-x-2">
                        <button
                            :disabled="saving"
                            class="px-4 py-2 bg-blue-600 text-white rounded"
                        >
                            {{ saving ? "Saving..." : "Update Student" }}
                        </button>
                        <router-link
                            to="/students"
                            class="text-sm text-gray-600"
                            >Cancel</router-link
                        >
                    </div>

                    <div v-if="error" class="text-sm text-red-600">
                        {{ error }}
                    </div>
                </form>
            </div>
        </div>
    </AppLayout>
</template>

<script setup>
import { ref, computed, watch } from 'vue';
import AppLayout from '@/components/AppLayout.vue';
import api from '@/utils/api';

const selectedClass = ref('');
const selectedSection = ref('');
const selectedDate = ref(new Date().toISOString().split('T')[0]);
const students = ref([]);
const attendance = ref({});
const loading = ref(false);
const submitting = ref(false);
const error = ref(null);
const success = ref(null);

const attendanceStats = computed(() => {
  const total = Object.keys(attendance.value).length;
  const present = Object.values(attendance.value).filter(s => s === 'present').length;
  const absent = Object.values(attendance.value).filter(s => s === 'absent').length;
  const late = Object.values(attendance.value).filter(s => s === 'late').length;
  const percentage = total > 0 ? ((present / total) * 100).toFixed(1) : 0;

  return { total, present, absent, late, percentage };
});

async function loadStudents() {
  if (!selectedClass.value || !selectedSection.value) {
    students.value = [];
    attendance.value = {};
    return;
  }

  loading.value = true;
  error.value = null;

  try {
    const res = await api.get('/students', {
      params: {
        class: selectedClass.value,
        section: selectedSection.value,
        per_page: 100
      }
    });

    students.value = res.data.data || res.data;
    
    // Initialize all as present by default
    attendance.value = {};
    students.value.forEach(student => {
      attendance.value[student.id] = 'present';
    });
  } catch (err) {
    error.value = 'Failed to load students';
    console.error('Load students error:', err);
  } finally {
    loading.value = false;
  }
}

function setAllStatus(status) {
  students.value.forEach(student => {
    attendance.value[student.id] = status;
  });
}

async function submitAttendance() {
  if (!selectedClass.value || !selectedSection.value) {
    error.value = 'Please select class and section';
    return;
  }

  if (Object.keys(attendance.value).length === 0) {
    error.value = 'No students to record attendance for';
    return;
  }

  submitting.value = true;
  error.value = null;
  success.value = null;

  try {
    const records = Object.entries(attendance.value).map(([studentId, status]) => ({
      student_id: parseInt(studentId),
      date: selectedDate.value,
      status: status,
      recorded_by: JSON.parse(localStorage.getItem('me') || '{}').id || 1
    }));

    await api.post('/attendance/bulk', { records });

    success.value = `Attendance recorded successfully for ${records.length} students!`;
    
    // Clear after 3 seconds
    setTimeout(() => {
      success.value = null;
    }, 3000);

  } catch (err) {
    error.value = err.response?.data?.message || 'Failed to submit attendance';
    console.error('Submit attendance error:', err);
  } finally {
    submitting.value = false;
  }
}

watch([selectedClass, selectedSection], () => {
  loadStudents();
});
</script>

<template>
  <AppLayout>
    <div class="space-y-6">
      <!-- Header -->
      <div class="bg-white shadow rounded-lg p-6">
        <h1 class="text-2xl font-bold text-gray-900">Record Attendance</h1>
        <p class="mt-1 text-sm text-gray-600">Mark student attendance for selected class</p>
      </div>

      <!-- Class Selection -->
      <div class="bg-white shadow rounded-lg p-6">
        <div class="grid grid-cols-1 gap-4 sm:grid-cols-3">
          <div>
            <label class="block text-sm font-medium text-gray-700 mb-1">Class *</label>
            <select
              v-model="selectedClass"
              class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-blue-500 focus:border-blue-500"
            >
              <option value="">Select Class</option>
              <option value="6">Class 6</option>
              <option value="7">Class 7</option>
              <option value="8">Class 8</option>
              <option value="9">Class 9</option>
              <option value="10">Class 10</option>
            </select>
          </div>
          <div>
            <label class="block text-sm font-medium text-gray-700 mb-1">Section *</label>
            <select
              v-model="selectedSection"
              class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-blue-500 focus:border-blue-500"
            >
              <option value="">Select Section</option>
              <option value="A">Section A</option>
              <option value="B">Section B</option>
              <option value="C">Section C</option>
            </select>
          </div>
          <div>
            <label class="block text-sm font-medium text-gray-700 mb-1">Date *</label>
            <input
              v-model="selectedDate"
              type="date"
              class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-blue-500 focus:border-blue-500"
            />
          </div>
        </div>
      </div>

      <!-- Success Message -->
      <div v-if="success" class="bg-green-50 border border-green-200 rounded-lg p-4">
        <p class="text-green-800">{{ success }}</p>
      </div>

      <!-- Error Message -->
      <div v-if="error" class="bg-red-50 border border-red-200 rounded-lg p-4">
        <p class="text-red-800">{{ error }}</p>
      </div>

      <!-- Loading State -->
      <div v-if="loading" class="bg-white shadow rounded-lg p-12 text-center">
        <div class="animate-spin rounded-full h-12 w-12 border-b-2 border-blue-600 mx-auto"></div>
        <p class="mt-4 text-gray-600">Loading students...</p>
      </div>

      <!-- Attendance Recording -->
      <template v-else-if="students.length > 0">
        <!-- Stats & Bulk Actions -->
        <div class="bg-white shadow rounded-lg p-6">
          <div class="flex flex-col sm:flex-row sm:items-center sm:justify-between space-y-4 sm:space-y-0">
            <div class="grid grid-cols-4 gap-4 flex-1">
              <div class="text-center">
                <div class="text-2xl font-bold text-gray-900">{{ attendanceStats.total }}</div>
                <div class="text-sm text-gray-500">Total</div>
              </div>
              <div class="text-center">
                <div class="text-2xl font-bold text-green-600">{{ attendanceStats.present }}</div>
                <div class="text-sm text-gray-500">Present</div>
              </div>
              <div class="text-center">
                <div class="text-2xl font-bold text-red-600">{{ attendanceStats.absent }}</div>
                <div class="text-sm text-gray-500">Absent</div>
              </div>
              <div class="text-center">
                <div class="text-2xl font-bold text-yellow-600">{{ attendanceStats.late }}</div>
                <div class="text-sm text-gray-500">Late</div>
              </div>
            </div>
            <div class="flex items-center space-x-2">
              <button
                @click="setAllStatus('present')"
                class="px-3 py-1.5 text-sm bg-green-100 text-green-700 rounded hover:bg-green-200"
              >
                All Present
              </button>
              <button
                @click="setAllStatus('absent')"
                class="px-3 py-1.5 text-sm bg-red-100 text-red-700 rounded hover:bg-red-200"
              >
                All Absent
              </button>
            </div>
          </div>
          <div class="mt-4 text-center">
            <span class="text-lg font-semibold text-blue-600">
              Attendance Rate: {{ attendanceStats.percentage }}%
            </span>
          </div>
        </div>

        <!-- Student List -->
        <div class="bg-white shadow rounded-lg overflow-hidden">
          <table class="min-w-full divide-y divide-gray-200">
            <thead class="bg-gray-50">
              <tr>
                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                  Student
                </th>
                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                  Student ID
                </th>
                <th class="px-6 py-3 text-center text-xs font-medium text-gray-500 uppercase tracking-wider">
                  Attendance Status
                </th>
              </tr>
            </thead>
            <tbody class="bg-white divide-y divide-gray-200">
              <tr v-for="student in students" :key="student.id" class="hover:bg-gray-50">
                <td class="px-6 py-4 whitespace-nowrap">
                  <div class="flex items-center">
                    <div class="h-10 w-10 flex-shrink-0">
                      <div class="h-10 w-10 rounded-full bg-blue-100 flex items-center justify-center">
                        <span class="text-blue-600 font-medium">
                          {{ student.name.charAt(0) }}
                        </span>
                      </div>
                    </div>
                    <div class="ml-4">
                      <div class="text-sm font-medium text-gray-900">{{ student.name }}</div>
                    </div>
                  </div>
                </td>
                <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                  {{ student.student_id }}
                </td>
                <td class="px-6 py-4 whitespace-nowrap">
                  <div class="flex justify-center space-x-2">
                    <button
                      @click="attendance[student.id] = 'present'"
                      class="px-4 py-2 rounded-md text-sm font-medium transition-colors"
                      :class="attendance[student.id] === 'present'
                        ? 'bg-green-600 text-white'
                        : 'bg-gray-100 text-gray-700 hover:bg-green-100'"
                    >
                      ✓ Present
                    </button>
                    <button
                      @click="attendance[student.id] = 'absent'"
                      class="px-4 py-2 rounded-md text-sm font-medium transition-colors"
                      :class="attendance[student.id] === 'absent'
                        ? 'bg-red-600 text-white'
                        : 'bg-gray-100 text-gray-700 hover:bg-red-100'"
                    >
                      ✗ Absent
                    </button>
                    <button
                      @click="attendance[student.id] = 'late'"
                      class="px-4 py-2 rounded-md text-sm font-medium transition-colors"
                      :class="attendance[student.id] === 'late'
                        ? 'bg-yellow-600 text-white'
                        : 'bg-gray-100 text-gray-700 hover:bg-yellow-100'"
                    >
                      ⏰ Late
                    </button>
                  </div>
                </td>
              </tr>
            </tbody>
          </table>
        </div>

        <!-- Submit Button -->
        <div class="bg-white shadow rounded-lg p-6">
          <button
            @click="submitAttendance"
            :disabled="submitting"
            class="w-full px-6 py-3 bg-blue-600 text-white rounded-md hover:bg-blue-700 disabled:opacity-50 disabled:cursor-not-allowed font-medium"
          >
            {{ submitting ? 'Submitting...' : 'Submit Attendance' }}
          </button>
        </div>
      </template>

      <!-- Empty State -->
      <div v-else class="bg-white shadow rounded-lg p-12 text-center">
        <div class="text-gray-400 text-6xl mb-4">👨‍🎓</div>
        <h3 class="text-lg font-medium text-gray-900 mb-2">Select Class and Section</h3>
        <p class="text-gray-500">Choose a class and section above to load students</p>
      </div>
    </div>
  </AppLayout>
</template>
<script setup>
import { ref } from 'vue';
import { useRouter, useRoute } from 'vue-router';
import api, { clearToken } from '@/utils/api';

const router = useRouter();
const route = useRoute();
const user = ref(JSON.parse(localStorage.getItem('me') || '{}'));
const showMobileMenu = ref(false);

async function logout() {
  try {
    await api.post('/sanctum/revoke');
  } catch (err) {
    console.error('Logout error:', err);
  } finally {
    clearToken();
    localStorage.removeItem('me');
    router.push('/login');
  }
}

const navItems = [
  { name: 'Dashboard', path: '/dashboard', icon: '📊' },
  { name: 'Students', path: '/students', icon: '👨‍🎓' },
  { name: 'Attendance', path: '/attendance', icon: '✓' }
];
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
              <h1 class="text-xl font-bold text-blue-600">📚 Mini Attendance</h1>
            </div>
            
            <!-- Desktop Navigation -->
            <div class="hidden sm:ml-6 sm:flex sm:space-x-8">
              <router-link
                v-for="item in navItems"
                :key="item.path"
                :to="item.path"
                class="inline-flex items-center px-1 pt-1 border-b-2 text-sm font-medium"
                :class="route.path === item.path 
                  ? 'border-blue-500 text-gray-900' 
                  : 'border-transparent text-gray-500 hover:border-gray-300 hover:text-gray-700'"
              >
                <span class="mr-2">{{ item.icon }}</span>
                {{ item.name }}
              </router-link>
            </div>
          </div>

          <!-- User menu -->
          <div class="hidden sm:ml-6 sm:flex sm:items-center">
            <div class="flex items-center space-x-4">
              <span class="text-sm text-gray-700">{{ user.name || 'User' }}</span>
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
              <svg class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 12h16M4 18h16" />
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
            :class="route.path === item.path
              ? 'bg-blue-50 border-blue-500 text-blue-700'
              : 'border-transparent text-gray-500 hover:bg-gray-50 hover:border-gray-300 hover:text-gray-700'"
          >
            {{ item.icon }} {{ item.name }}
          </router-link>
        </div>
        <div class="pt-4 pb-3 border-t border-gray-200">
          <div class="flex items-center px-4">
            <div class="text-base font-medium text-gray-800">{{ user.name }}</div>
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
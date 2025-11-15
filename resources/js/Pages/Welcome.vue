<script setup>
import { Head, Link } from '@inertiajs/vue3';

defineProps({
    canLogin: {
        type: Boolean,
    },
    canRegister: {
        type: Boolean,
    },
    laravelVersion: {
        type: String,
        required: true,
    },
    phpVersion: {
        type: String,
        required: true,
    },
});
</script>

<template>
  <Head title="Mini Attendance — Welcome" />

  <div class="min-h-screen bg-gradient-to-br from-gray-50 via-white to-gray-100 dark:from-gray-900 dark:via-black dark:to-gray-900 text-gray-900 dark:text-gray-100">
    <!-- Decorative background elements -->
    <div class="absolute inset-0 overflow-hidden pointer-events-none">
      <div class="absolute -top-40 -right-40 w-80 h-80 bg-blue-400/10 dark:bg-blue-500/5 rounded-full blur-3xl"></div>
      <div class="absolute top-1/2 -left-40 w-96 h-96 bg-purple-400/10 dark:bg-purple-500/5 rounded-full blur-3xl"></div>
      <div class="absolute bottom-0 right-1/4 w-64 h-64 bg-pink-400/10 dark:bg-pink-500/5 rounded-full blur-3xl"></div>
    </div>

    <div class="relative">
      <!-- Header -->
      <header class="container mx-auto px-4 sm:px-6 lg:px-8 py-6">
        <div class="flex flex-col sm:flex-row items-center justify-between gap-4">
          <!-- Logo -->
          <div class="flex items-center gap-3">
            <div class="w-10 h-10 bg-gradient-to-br from-blue-500 to-purple-600 rounded-lg flex items-center justify-center shadow-lg">
              <svg class="w-6 h-6 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" />
              </svg>
            </div>
            <div>
              <h1 class="text-xl font-bold bg-gradient-to-r from-blue-600 to-purple-600 dark:from-blue-400 dark:to-purple-400 bg-clip-text text-transparent">
                Mini Attendance
              </h1>
              <p class="text-xs text-gray-500 dark:text-gray-400">Smart School Management</p>
            </div>
          </div>

          <!-- Navigation -->
          <nav v-if="canLogin" class="flex flex-wrap items-center justify-center gap-2">
            <Link 
              v-if="$page.props.auth.user" 
              :href="route('dashboard')" 
              class="px-4 py-2 rounded-lg text-sm font-medium bg-white dark:bg-gray-800 border border-gray-200 dark:border-gray-700 hover:bg-gray-50 dark:hover:bg-gray-700 transition-all shadow-sm"
            >
              Dashboard
            </Link>
            <template v-else>
              <Link 
                :href="route('login')" 
                class="px-4 py-2 rounded-lg text-sm font-medium text-gray-700 dark:text-gray-300 hover:bg-white/50 dark:hover:bg-gray-800/50 transition-all"
              >
                Log in
              </Link>
              <Link 
                v-if="canRegister" 
                :href="route('register')" 
                class="px-4 py-2 rounded-lg text-sm font-medium bg-gradient-to-r from-blue-500 to-purple-600 text-white hover:from-blue-600 hover:to-purple-700 transition-all shadow-md"
              >
                Register
              </Link>
            </template>
          </nav>
        </div>
      </header>

      <!-- Hero Section -->
      <section class="container mx-auto px-4 sm:px-6 lg:px-8 py-12 sm:py-20">
        <div class="max-w-4xl mx-auto text-center">
          <div class="inline-flex items-center gap-2 px-4 py-2 rounded-full bg-blue-50 dark:bg-blue-900/20 border border-blue-200 dark:border-blue-800 mb-8">
            <span class="w-2 h-2 bg-blue-500 rounded-full animate-pulse"></span>
            <span class="text-sm font-medium text-blue-700 dark:text-blue-300">Laravel + Vue 3 + Inertia Demo</span>
          </div>

          <h2 class="text-4xl sm:text-5xl lg:text-6xl font-bold mb-6 leading-tight">
            Welcome to
            <span class="bg-gradient-to-r from-blue-600 via-purple-600 to-pink-600 dark:from-blue-400 dark:via-purple-400 dark:to-pink-400 bg-clip-text text-transparent">
              Mini Attendance
            </span>
          </h2>

          <p class="text-lg sm:text-xl text-gray-600 dark:text-gray-400 mb-8 max-w-2xl mx-auto leading-relaxed">
            A modern school attendance system showcasing API-driven architecture with Laravel backend and Vue 3 SPA frontend. 
            Complete with Sanctum authentication, Redis caching, and comprehensive testing.
          </p>

          <!-- CTA Buttons -->
          <div class="flex flex-col sm:flex-row gap-4 justify-center mb-12">
            <Link 
              :href="route('api.login')" 
              class="px-8 py-4 rounded-xl text-base font-semibold bg-gradient-to-r from-blue-500 to-purple-600 text-white hover:from-blue-600 hover:to-purple-700 transition-all shadow-lg hover:shadow-xl transform hover:-translate-y-0.5"
            >
              Get Started with API Login
            </Link>
            <Link 
              :href="route('spa.dashboard')" 
              class="px-8 py-4 rounded-xl text-base font-semibold bg-white dark:bg-gray-800 text-gray-900 dark:text-gray-100 border-2 border-gray-200 dark:border-gray-700 hover:border-blue-500 dark:hover:border-blue-500 transition-all shadow-md hover:shadow-lg"
            >
              Explore Dashboard
            </Link>
          </div>

          <!-- Quick Stats -->
          <div class="grid grid-cols-2 sm:grid-cols-4 gap-4 max-w-3xl mx-auto">
            <div class="p-4 rounded-xl bg-white/50 dark:bg-gray-800/50 backdrop-blur border border-gray-200 dark:border-gray-700">
              <div class="text-2xl sm:text-3xl font-bold text-blue-600 dark:text-blue-400 mb-1">100%</div>
              <div class="text-xs sm:text-sm text-gray-600 dark:text-gray-400">API Coverage</div>
            </div>
            <div class="p-4 rounded-xl bg-white/50 dark:bg-gray-800/50 backdrop-blur border border-gray-200 dark:border-gray-700">
              <div class="text-2xl sm:text-3xl font-bold text-purple-600 dark:text-purple-400 mb-1">Fast</div>
              <div class="text-xs sm:text-sm text-gray-600 dark:text-gray-400">Redis Cache</div>
            </div>
            <div class="p-4 rounded-xl bg-white/50 dark:bg-gray-800/50 backdrop-blur border border-gray-200 dark:border-gray-700">
              <div class="text-2xl sm:text-3xl font-bold text-pink-600 dark:text-pink-400 mb-1">Secure</div>
              <div class="text-xs sm:text-sm text-gray-600 dark:text-gray-400">Sanctum Auth</div>
            </div>
            <div class="p-4 rounded-xl bg-white/50 dark:bg-gray-800/50 backdrop-blur border border-gray-200 dark:border-gray-700">
              <div class="text-2xl sm:text-3xl font-bold text-green-600 dark:text-green-400 mb-1">Tested</div>
              <div class="text-xs sm:text-sm text-gray-600 dark:text-gray-400">Unit Tests</div>
            </div>
          </div>
        </div>
      </section>

      <!-- Features Grid -->
      <section class="container mx-auto px-4 sm:px-6 lg:px-8 py-12 sm:py-16">
        <div class="max-w-6xl mx-auto">
          <div class="text-center mb-12">
            <h3 class="text-3xl font-bold mb-4">Quick Access</h3>
            <p class="text-gray-600 dark:text-gray-400">Jump right into the core features of the system</p>
          </div>

          <div class="grid sm:grid-cols-2 lg:grid-cols-3 gap-6">
            <!-- Students Card -->
            <Link 
              :href="route('students.index')" 
              class="group p-6 rounded-2xl bg-white dark:bg-gray-800 border border-gray-200 dark:border-gray-700 hover:border-blue-500 dark:hover:border-blue-500 transition-all hover:shadow-xl transform hover:-translate-y-1"
            >
              <div class="w-12 h-12 bg-blue-100 dark:bg-blue-900/30 rounded-xl flex items-center justify-center mb-4 group-hover:scale-110 transition-transform">
                <svg class="w-6 h-6 text-blue-600 dark:text-blue-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4.354a4 4 0 110 5.292M15 21H3v-1a6 6 0 0112 0v1zm0 0h6v-1a6 6 0 00-9-5.197M13 7a4 4 0 11-8 0 4 4 0 018 0z" />
                </svg>
              </div>
              <h4 class="text-xl font-semibold mb-2 group-hover:text-blue-600 dark:group-hover:text-blue-400 transition-colors">Students</h4>
              <p class="text-sm text-gray-600 dark:text-gray-400 mb-4">Manage student records, view profiles, and track enrollment data with full CRUD operations.</p>
              <div class="flex items-center text-sm font-medium text-blue-600 dark:text-blue-400">
                Open Students <span class="ml-1 group-hover:translate-x-1 transition-transform">→</span>
              </div>
            </Link>

            <!-- Attendance Card -->
            <Link 
              :href="route('attendance.record')" 
              class="group p-6 rounded-2xl bg-white dark:bg-gray-800 border border-gray-200 dark:border-gray-700 hover:border-purple-500 dark:hover:border-purple-500 transition-all hover:shadow-xl transform hover:-translate-y-1"
            >
              <div class="w-12 h-12 bg-purple-100 dark:bg-purple-900/30 rounded-xl flex items-center justify-center mb-4 group-hover:scale-110 transition-transform">
                <svg class="w-6 h-6 text-purple-600 dark:text-purple-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2m-6 9l2 2 4-4" />
                </svg>
              </div>
              <h4 class="text-xl font-semibold mb-2 group-hover:text-purple-600 dark:group-hover:text-purple-400 transition-colors">Attendance</h4>
              <p class="text-sm text-gray-600 dark:text-gray-400 mb-4">Record daily attendance, bulk operations, and generate comprehensive monthly reports.</p>
              <div class="flex items-center text-sm font-medium text-purple-600 dark:text-purple-400">
                Record Attendance <span class="ml-1 group-hover:translate-x-1 transition-transform">→</span>
              </div>
            </Link>

            <!-- API Login Card -->
            <Link 
              :href="route('api.login')" 
              class="group p-6 rounded-2xl bg-white dark:bg-gray-800 border border-gray-200 dark:border-gray-700 hover:border-pink-500 dark:hover:border-pink-500 transition-all hover:shadow-xl transform hover:-translate-y-1"
            >
              <div class="w-12 h-12 bg-pink-100 dark:bg-pink-900/30 rounded-xl flex items-center justify-center mb-4 group-hover:scale-110 transition-transform">
                <svg class="w-6 h-6 text-pink-600 dark:text-pink-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 7a2 2 0 012 2m4 0a6 6 0 01-7.743 5.743L11 17H9v2H7v2H4a1 1 0 01-1-1v-2.586a1 1 0 01.293-.707l5.964-5.964A6 6 0 1121 9z" />
                </svg>
              </div>
              <h4 class="text-xl font-semibold mb-2 group-hover:text-pink-600 dark:group-hover:text-pink-400 transition-colors">API Login</h4>
              <p class="text-sm text-gray-600 dark:text-gray-400 mb-4">Authenticate and receive a personal access token to interact with the RESTful API.</p>
              <div class="flex items-center text-sm font-medium text-pink-600 dark:text-pink-400">
                Get Token <span class="ml-1 group-hover:translate-x-1 transition-transform">→</span>
              </div>
            </Link>

            <!-- Dashboard Card -->
            <Link 
              :href="route('spa.dashboard')" 
              class="group p-6 rounded-2xl bg-white dark:bg-gray-800 border border-gray-200 dark:border-gray-700 hover:border-green-500 dark:hover:border-green-500 transition-all hover:shadow-xl transform hover:-translate-y-1"
            >
              <div class="w-12 h-12 bg-green-100 dark:bg-green-900/30 rounded-xl flex items-center justify-center mb-4 group-hover:scale-110 transition-transform">
                <svg class="w-6 h-6 text-green-600 dark:text-green-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z" />
                </svg>
              </div>
              <h4 class="text-xl font-semibold mb-2 group-hover:text-green-600 dark:group-hover:text-green-400 transition-colors">SPA Dashboard</h4>
              <p class="text-sm text-gray-600 dark:text-gray-400 mb-4">View analytics, statistics, and insights in a beautiful single-page application interface.</p>
              <div class="flex items-center text-sm font-medium text-green-600 dark:text-green-400">
                View Analytics <span class="ml-1 group-hover:translate-x-1 transition-transform">→</span>
              </div>
            </Link>

            <!-- Reports Card -->
            <div class="group p-6 rounded-2xl bg-white dark:bg-gray-800 border border-gray-200 dark:border-gray-700 hover:border-orange-500 dark:hover:border-orange-500 transition-all hover:shadow-xl transform hover:-translate-y-1">
              <div class="w-12 h-12 bg-orange-100 dark:bg-orange-900/30 rounded-xl flex items-center justify-center mb-4 group-hover:scale-110 transition-transform">
                <svg class="w-6 h-6 text-orange-600 dark:text-orange-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 17v-2m3 2v-4m3 4v-6m2 10H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z" />
                </svg>
              </div>
              <h4 class="text-xl font-semibold mb-2 group-hover:text-orange-600 dark:group-hover:text-orange-400 transition-colors">Monthly Reports</h4>
              <p class="text-sm text-gray-600 dark:text-gray-400 mb-4">Generate detailed attendance reports with statistics, trends, and exportable data.</p>
              <div class="flex items-center text-sm font-medium text-orange-600 dark:text-orange-400">
                Coming Soon <span class="ml-1">✨</span>
              </div>
            </div>

            <!-- API Docs Card -->
            <div class="group p-6 rounded-2xl bg-white dark:bg-gray-800 border border-gray-200 dark:border-gray-700 hover:border-indigo-500 dark:hover:border-indigo-500 transition-all hover:shadow-xl transform hover:-translate-y-1">
              <div class="w-12 h-12 bg-indigo-100 dark:bg-indigo-900/30 rounded-xl flex items-center justify-center mb-4 group-hover:scale-110 transition-transform">
                <svg class="w-6 h-6 text-indigo-600 dark:text-indigo-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 20l4-16m4 4l4 4-4 4M6 16l-4-4 4-4" />
                </svg>
              </div>
              <h4 class="text-xl font-semibold mb-2 group-hover:text-indigo-600 dark:group-hover:text-indigo-400 transition-colors">API Documentation</h4>
              <p class="text-sm text-gray-600 dark:text-gray-400 mb-4">Comprehensive RESTful API docs with authentication, endpoints, and examples.</p>
              <div class="flex items-center text-sm font-medium text-indigo-600 dark:text-indigo-400">
                View Docs <span class="ml-1">📚</span>
              </div>
            </div>
          </div>
        </div>
      </section>

      <!-- Tech Stack Section -->
      <section class="container mx-auto px-4 sm:px-6 lg:px-8 py-12 sm:py-16">
        <div class="max-w-4xl mx-auto">
          <div class="p-8 sm:p-12 rounded-3xl bg-gradient-to-br from-blue-50 via-purple-50 to-pink-50 dark:from-gray-800 dark:via-gray-800 dark:to-gray-800 border border-gray-200 dark:border-gray-700">
            <h3 class="text-2xl sm:text-3xl font-bold mb-6 text-center">Built With Modern Tech</h3>
            <div class="grid grid-cols-2 sm:grid-cols-3 lg:grid-cols-6 gap-4 sm:gap-6">
              <div class="text-center">
                <div class="w-12 h-12 mx-auto mb-2 bg-white dark:bg-gray-700 rounded-xl flex items-center justify-center shadow-md">
                  <span class="text-2xl">🔴</span>
                </div>
                <div class="text-sm font-semibold">Laravel</div>
              </div>
              <div class="text-center">
                <div class="w-12 h-12 mx-auto mb-2 bg-white dark:bg-gray-700 rounded-xl flex items-center justify-center shadow-md">
                  <span class="text-2xl">💚</span>
                </div>
                <div class="text-sm font-semibold">Vue 3</div>
              </div>
              <div class="text-center">
                <div class="w-12 h-12 mx-auto mb-2 bg-white dark:bg-gray-700 rounded-xl flex items-center justify-center shadow-md">
                  <span class="text-2xl">⚡</span>
                </div>
                <div class="text-sm font-semibold">Inertia</div>
              </div>
              <div class="text-center">
                <div class="w-12 h-12 mx-auto mb-2 bg-white dark:bg-gray-700 rounded-xl flex items-center justify-center shadow-md">
                  <span class="text-2xl">🔐</span>
                </div>
                <div class="text-sm font-semibold">Sanctum</div>
              </div>
              <div class="text-center">
                <div class="w-12 h-12 mx-auto mb-2 bg-white dark:bg-gray-700 rounded-xl flex items-center justify-center shadow-md">
                  <span class="text-2xl">🚀</span>
                </div>
                <div class="text-sm font-semibold">Redis</div>
              </div>
              <div class="text-center">
                <div class="w-12 h-12 mx-auto mb-2 bg-white dark:bg-gray-700 rounded-xl flex items-center justify-center shadow-md">
                  <span class="text-2xl">🎨</span>
                </div>
                <div class="text-sm font-semibold">Tailwind</div>
              </div>
            </div>
          </div>
        </div>
      </section>

      <!-- Getting Started Section -->
      <section class="container mx-auto px-4 sm:px-6 lg:px-8 py-12 sm:py-16">
        <div class="max-w-4xl mx-auto">
          <div class="p-8 sm:p-12 rounded-3xl bg-white dark:bg-gray-800 border border-gray-200 dark:border-gray-700 shadow-xl">
            <h3 class="text-2xl sm:text-3xl font-bold mb-6">Quick Start Guide</h3>
            <div class="space-y-4">
              <div class="flex gap-4">
                <div class="flex-shrink-0 w-8 h-8 bg-blue-100 dark:bg-blue-900/30 rounded-full flex items-center justify-center text-blue-600 dark:text-blue-400 font-bold">1</div>
                <div>
                  <h4 class="font-semibold mb-1">Get Your API Token</h4>
                  <p class="text-sm text-gray-600 dark:text-gray-400">Navigate to <span class="font-mono bg-gray-100 dark:bg-gray-700 px-2 py-1 rounded">API Login</span> and authenticate with <span class="font-mono bg-gray-100 dark:bg-gray-700 px-2 py-1 rounded">admin@example.com</span> / <span class="font-mono bg-gray-100 dark:bg-gray-700 px-2 py-1 rounded">secret</span></p>
                </div>
              </div>
              <div class="flex gap-4">
                <div class="flex-shrink-0 w-8 h-8 bg-purple-100 dark:bg-purple-900/30 rounded-full flex items-center justify-center text-purple-600 dark:text-purple-400 font-bold">2</div>
                <div>
                  <h4 class="font-semibold mb-1">Explore Students</h4>
                  <p class="text-sm text-gray-600 dark:text-gray-400">Visit the Students page to view, add, edit, and manage student records using the saved token automatically.</p>
                </div>
              </div>
              <div class="flex gap-4">
                <div class="flex-shrink-0 w-8 h-8 bg-pink-100 dark:bg-pink-900/30 rounded-full flex items-center justify-center text-pink-600 dark:text-pink-400 font-bold">3</div>
                <div>
                  <h4 class="font-semibold mb-1">Record Attendance</h4>
                  <p class="text-sm text-gray-600 dark:text-gray-400">Head to the Attendance page to mark present/absent for students and verify database entries in real-time.</p>
                </div>
              </div>
              <div class="flex gap-4">
                <div class="flex-shrink-0 w-8 h-8 bg-green-100 dark:bg-green-900/30 rounded-full flex items-center justify-center text-green-600 dark:text-green-400 font-bold">4</div>
                <div>
                  <h4 class="font-semibold mb-1">View Dashboard</h4>
                  <p class="text-sm text-gray-600 dark:text-gray-400">Check out the SPA Dashboard for analytics, statistics, and a complete overview of the system.</p>
                </div>
              </div>
            </div>
          </div>
        </div>
      </section>

      <!-- Footer -->
      <footer class="container mx-auto px-4 sm:px-6 lg:px-8 py-12 text-center">
        <div class="max-w-4xl mx-auto">
          <div class="flex flex-col sm:flex-row items-center justify-center gap-4 mb-6">
            <div class="flex items-center gap-2 text-sm text-gray-600 dark:text-gray-400">
              <span class="font-mono">Laravel v{{ laravelVersion }}</span>
              <span>•</span>
              <span class="font-mono">PHP v{{ phpVersion }}</span>
            </div>
          </div>
          <p class="text-sm text-gray-500 dark:text-gray-500">
            Built with ❤️ as a demonstration of modern web development practices
          </p>
        </div>
      </footer>
    </div>
  </div>
</template>
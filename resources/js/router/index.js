import { createRouter, createWebHistory } from "vue-router";

const routes = [
    {
        path: "/login",
        name: "login",
        component: () => import("../views/LoginView.vue"),
        meta: { requiresAuth: false },
    },
    {
        path: "/",
        redirect: "/dashboard",
    },
    {
        path: "/dashboard",
        name: "dashboard",
        component: () => import("../views/DashboardView.vue"),
        meta: { requiresAuth: true },
    },
    {
        path: "/students",
        name: "students",
        component: () => import("../views/StudentsView.vue"),
        meta: { requiresAuth: true },
    },
    {
        path: "/reports",
        name: "reports",
        component: () => import("@/views/ReportsView.vue"),
        meta: { requiresAuth: true },
    },
    {
        path: "/students/create",
        name: "students.create",
        component: () => import("../views/Students/Create.vue"),
        meta: { requiresAuth: true },
    },
    {
        path: "/students/:id/edit",
        name: "students.edit",
        component: () => import("../views/Students/Edit.vue"),
        meta: { requiresAuth: true },
        props: true,
    },
    {
        path: "/attendance",
        name: "attendance",
        component: () => import("../views/AttendanceView.vue"),
        meta: { requiresAuth: true },
    },
];

const router = createRouter({
    history: createWebHistory(),
    routes,
});

// Navigation guard
router.beforeEach((to, from, next) => {
    const token = localStorage.getItem("api_token");

    if (to.meta.requiresAuth && !token) {
        next("/login");
    } else if (to.path === "/login" && token) {
        next("/dashboard");
    } else {
        next();
    }
});

export default router;

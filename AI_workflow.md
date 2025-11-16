# AI_WORKFLOW.md

## Overview

This document describes how AI tools (ChatGPT / Claude) were used during the development of the Mini School Attendance System. It includes specific prompts, examples, and details on how AI improved productivity while maintaining clean, maintainable code.

---

## 1. Parts of the Project Built With AI Assistance

Below is a list of sections where AI was used to support development:

### Backend (Laravel)

- Designing base architecture for Student & Attendance models
- Generating boilerplate CRUD controllers
- Creating Service Layer structure (AttendanceService)
- Writing Redis caching strategy
- Creating custom Artisan command
- Generating Events + Broadcasting logic
- Helping design a clean API response format using Laravel Resources
- Writing test cases for:
  - Bulk attendance
  - Monthly report
  - Broadcast authentication

### Frontend (Vue 3)

- Assisting with Vue Composition API patterns
- Designing reusable AppLayout
- Writing state logic for attendance percentage
- Creating notification dropdown + Echo subscription
- Generating Chart.js configuration
- Creating StudentsView (filters, pagination, table layout)

### General

- Refactoring large code blocks for readability
- Explaining tricky Laravel behaviors (upsert, broadcasting routes, cache invalidation)
- Debugging Echo authentication issues
- Providing Docker + Redis setup instructions
- Formatting README sections

---

## 2. Three Example Prompts and How They Helped

### Prompt 1 – Bulk Attendance Logic

**"Help me design a Laravel Service layer for bulk attendance upsert with cache invalidation per month and class."**

**How it helped:**
- AI generated a clean structure for a bulk upsert + cache invalidation flow, which was later customized manually.
- It saved time by generating the base logic, ensuring the service followed SOLID principles.

### Prompt 2 – Vue.js Real-Time Notifications

**"Write a Vue Composition API listener that subscribes to a private Echo channel and updates a notifications dropdown with unseen count."**

**How it helped:**
- AI produced a reusable pattern for:
  - Echo subscription
  - pushNotification() logic
  - unread counter
  - sound feedback
- This sped up UI development and reduced debugging time.

### Prompt 3 – Redis caching with docker

**"as this was the requirement. should we do the caching now.? since I am noob in terms of using redis. so pretend I don't know anything about caching and redis. I need you to guide me step by step. with codes and the theoretical knowledge along the way. so I don't get stuck in the code and know what I am doing"**

**How it helped:**  
AI produced a beginner-friendly, step-by-step Redis + Laravel caching guide that included:

1. **Theory** — what caching is, TTL, cache keys, cache invalidation strategies (why and when to invalidate), and pros/cons.  
2. **Environment setup** — how to run Redis locally (including using Docker to spin up a Redis container), which `.env` variables to set (`CACHE_DRIVER=redis`, `REDIS_HOST`, etc.), and how to verify Redis is running.  
3. **Laravel config** — exact `.env` settings and `config/cache.php` adjustments so Laravel uses Redis for `Cache::remember()` and `Cache::forget()`.  
4. **Code examples** — concrete Laravel snippets (using `Cache::remember`, `Cache::forget`, `Cache::tags` where appropriate) and how to apply them inside the `AttendanceService` monthly report caching logic.  
5. **Testing tips** — how to use `CACHE_DRIVER=array` or an in-memory SQLite database for automated tests, and how to run feature tests without depending on an external Redis server.  
6. **Debugging & verification** — commands to inspect Redis with `redis-cli`, how to list keys, flush cache safely, and verify that Laravel is actually writing/reading the cache.  

Overall, AI produced both the **Redis Docker setup** and the **Laravel caching implementation**, turning something unfamiliar into a clear, working solution.

## 3. How AI Improved Development Speed

Using AI significantly reduced development time in these ways:

### ✔ Faster boilerplate creation

Models, controllers, and service structures were generated quickly, allowing focus on business logic instead of repetitive code.

### ✔ Debugging assistance

AI helped identify:
- Why Echo was not receiving events
- Why broadcasting/auth needed to be inside auth:sanctum
- Why Redis invalidation wasn't clearing class-level cache

### ✔ Documentation generation

AI produced:
- Inline comments
- Correct Laravel patterns
- Clean Vue component structure
- Accurate Pusher/Echo setup logic

### ✔ Reduced research time

Instead of searching docs manually (especially for CarbonPeriod, Redis keys, upsert syntax, Chart.js config), AI returned answers instantly.

### Overall Result

**AI probably saved 6–10 hours** and reduced cognitive load for repetitive or boilerplate tasks.

---

## 4. What Was Manually Coded vs AI-Generated

### Manually Implemented

- Final business logic in AttendanceService (aggregation, cache key structure)
- All Vue UI layouts (actual styling, UX decisions)
- Notification dropdown interactions and transitions
- Debugging event payload mismatches
- Validations and request rules
- Fixing API responses to match front-end expectations
- Custom pagination, filters, and student photo upload logic
- Final testing (running, adjusting, mocking, debugging)

### AI-Generated (with modifications)

- Initial skeletons for:
  - Models
  - Controllers
  - Events
  - CSV command
- First draft of Vue Composition API logic
- First draft of feature tests
- Echo subscription boilerplate
- Docker Redis setup instructions

### Blended (AI + manual refinement)

- Monthly report caching strategy
- Bulk attendance upsert flow
- Chart.js dataset/option structure
- StudentsView filter workflow
- AppLayout notifications UX

---

## ✔ Conclusion

AI tools were used responsibly to speed up development, generate boilerplate, debug complex Laravel behaviors, and produce clean documentation. However, core decisions, architecture design, and final implementations were manually written to ensure code quality, correctness, and maintainability.
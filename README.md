# Mini School Attendance System

A modern school attendance management system built with Laravel and Vue.js, featuring real-time notifications, attendance tracking, and comprehensive reporting.

## Features

- 📊 Real-time attendance tracking and analytics
- 🔔 Live notifications using Laravel Broadcasting and Pusher
- 📈 Interactive charts and statistics with Chart.js
- 📅 Monthly attendance reports with CSV export
- 🎯 Bulk attendance management
- ⚡ Redis caching for optimal performance
- 🔐 Secure authentication with Laravel Sanctum
- 📱 Responsive Vue.js frontend with Composition API

## Tech Stack

**Backend:**
- Laravel 10+
- MySQL
- Redis
- Laravel Broadcasting with Pusher
- Laravel Sanctum

**Frontend:**
- Vue.js 3 (Composition API)
- Vite
- Chart.js
- Laravel Echo
- Tailwind CSS

## Prerequisites

Before you begin, ensure you have the following installed:

- PHP 8.1 or higher
- Composer
- Node.js & npm
- MySQL
- Docker Desktop
- Git

## Installation

Follow these steps to set up the project locally:

### 1. Clone the Repository

```bash
git clone https://github.com/TanjilurJim/mini-attendance.git
cd mini-attendance
```

### 2. Install Dependencies

Install PHP dependencies:
```bash
composer install
```

Install JavaScript dependencies:
```bash
npm install
```

### 3. Database Setup

1. Open **phpMyAdmin** and create a new database:
   - Database name: `miniattendance`

2. Import the provided SQL file:
   - Go to the `miniattendance` database
   - Click on the **Import** tab
   - Choose the file `mini_attendance.sql` from the project root
   - Click **Go** to import

### 4. Environment Configuration

1. Use the provided `.env` file in the mail

2. Make sure the following settings are configured:

```env
APP_URL=http://mini-attendance.test

DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=miniattendance
DB_USERNAME=root
DB_PASSWORD=

BROADCAST_DRIVER=pusher
CACHE_DRIVER=redis
QUEUE_CONNECTION=sync
SESSION_DRIVER=file

REDIS_HOST=127.0.0.1
REDIS_PASSWORD=null
REDIS_PORT=6379

PUSHER_APP_ID=2029269
PUSHER_APP_KEY=c87da674272b46d4bcd7
PUSHER_APP_SECRET=5e1fb6f615eb6240d019
PUSHER_APP_CLUSTER=ap2
```

3. Generate application key:
```bash
php artisan key:generate
```

### 5. Set Up Redis with Docker

1. Make sure **Docker Desktop** is running

2. Run Redis container:
```bash
docker run -d --name redis -p 6379:6379 redis:7-alpine
```

3. Verify Redis is running:
```bash
docker ps
```

You should see the `redis` container in the list.

### 6. Configure Local Domain (Optional)

Add the following to your hosts file:

**Windows:** `C:\Windows\System32\drivers\etc\hosts`  
**Mac/Linux:** `/etc/hosts`

```
127.0.0.1    mini-attendance.test
```

### 7. Start the Development Server

Run the development server:
```bash
npm run dev
```



### 8. Access the Application

Visit: **http://mini-attendance.test** (or **http://127.0.0.1:8000**)

**Default Login Credentials:**
- **Email:** `admin@example.com`
- **Password:** `secret`

## Additional Commands

### Generate Monthly Reports

```bash
php artisan attendance:generate-report {month} {class}
```

Example:
```bash
php artisan attendance:generate-report 2024-01 "Class 10"
```

### Clear Cache

```bash
php artisan cache:clear
php artisan config:clear
php artisan route:clear
```

### Run Tests

```bash
php artisan test
```

## Project Structure

```
mini-attendance/
├── app/
│   ├── Http/Controllers/     # API Controllers
│   ├── Models/                # Eloquent Models
│   ├── Services/              # Business Logic Layer
│   └── Events/                # Broadcasting Events
├── resources/
│   └── js/
│       ├── components/        # Vue Components
│       ├── views/             # Vue Views
│       └── app.js             # Main Vue App
├── routes/
│   ├── api.php                # API Routes
│   └── channels.php           # Broadcasting Channels
├── database/
│   └── migrations/            # Database Migrations
└── tests/                     # Feature & Unit Tests
```

## Troubleshooting

### Redis Connection Issues

If you encounter Redis connection errors:

1. Check if Docker is running: `docker ps`
2. Restart Redis container: `docker restart redis`
3. Verify Redis port: `docker port redis`

### Broadcasting Not Working

1. Verify Pusher credentials in `.env`
2. Clear config cache: `php artisan config:clear`
3. Check browser console for Echo connection errors

### Database Connection Failed

1. Verify MySQL is running
2. Check database credentials in `.env`
3. Ensure `miniattendance` database exists



## License

This project is open-sourced software licensed under the [MIT license](https://opensource.org/licenses/MIT).

## Support

For issues and questions, please open an issue on the [GitHub repository](https://github.com/TanjilurJim/mini-attendance/issues).

---


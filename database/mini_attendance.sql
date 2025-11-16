-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Nov 16, 2025 at 12:47 PM
-- Server version: 8.0.30
-- PHP Version: 8.3.15

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `mini_attendance`
--

-- --------------------------------------------------------

--
-- Table structure for table `attendances`
--

CREATE TABLE `attendances` (
  `id` bigint UNSIGNED NOT NULL,
  `student_id` bigint UNSIGNED NOT NULL,
  `date` date NOT NULL,
  `status` enum('present','absent','late') COLLATE utf8mb4_unicode_ci NOT NULL,
  `note` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `recorded_by` bigint UNSIGNED DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `attendances`
--

INSERT INTO `attendances` (`id`, `student_id`, `date`, `status`, `note`, `recorded_by`, `created_at`, `updated_at`) VALUES
(1, 10, '2025-11-16', 'late', NULL, 1, '2025-11-16 00:02:50', '2025-11-16 00:17:14'),
(2, 27, '2025-11-16', 'present', NULL, 1, '2025-11-16 00:02:50', '2025-11-16 00:17:14'),
(3, 36, '2025-11-16', 'present', NULL, 1, '2025-11-16 00:02:50', '2025-11-16 00:17:14'),
(4, 51, '2025-11-16', 'present', NULL, 1, '2025-11-16 00:02:50', '2025-11-16 00:17:14'),
(5, 53, '2025-11-16', 'present', NULL, 1, '2025-11-16 00:02:50', '2025-11-16 00:17:14'),
(6, 61, '2025-11-16', 'present', NULL, 1, '2025-11-16 00:02:50', '2025-11-16 00:17:14'),
(7, 77, '2025-11-16', 'present', NULL, 1, '2025-11-16 00:02:50', '2025-11-16 00:17:14'),
(8, 84, '2025-11-16', 'present', NULL, 1, '2025-11-16 00:02:50', '2025-11-16 00:17:14'),
(9, 88, '2025-11-16', 'present', NULL, 1, '2025-11-16 00:02:50', '2025-11-16 00:17:14'),
(10, 89, '2025-11-16', 'present', NULL, 1, '2025-11-16 00:02:50', '2025-11-16 00:17:14'),
(11, 94, '2025-11-16', 'present', NULL, 1, '2025-11-16 00:02:50', '2025-11-16 00:17:14'),
(12, 99, '2025-11-16', 'present', NULL, 1, '2025-11-16 00:02:50', '2025-11-16 00:17:14'),
(26, 7, '2025-11-17', 'present', NULL, 1, '2025-11-16 02:59:09', '2025-11-16 02:59:09'),
(27, 8, '2025-11-17', 'present', NULL, 1, '2025-11-16 02:59:09', '2025-11-16 02:59:09'),
(28, 24, '2025-11-17', 'present', NULL, 1, '2025-11-16 02:59:09', '2025-11-16 02:59:09'),
(29, 25, '2025-11-17', 'present', NULL, 1, '2025-11-16 02:59:09', '2025-11-16 02:59:09'),
(30, 29, '2025-11-17', 'present', NULL, 1, '2025-11-16 02:59:09', '2025-11-16 02:59:09'),
(31, 50, '2025-11-17', 'present', NULL, 1, '2025-11-16 02:59:09', '2025-11-16 02:59:09'),
(32, 55, '2025-11-17', 'present', NULL, 1, '2025-11-16 02:59:09', '2025-11-16 02:59:09'),
(33, 67, '2025-11-17', 'present', NULL, 1, '2025-11-16 02:59:09', '2025-11-16 02:59:09'),
(34, 70, '2025-11-17', 'present', NULL, 1, '2025-11-16 02:59:09', '2025-11-16 02:59:09'),
(35, 76, '2025-11-17', 'present', NULL, 1, '2025-11-16 02:59:09', '2025-11-16 02:59:09'),
(36, 91, '2025-11-17', 'present', NULL, 1, '2025-11-16 02:59:09', '2025-11-16 02:59:09'),
(37, 98, '2025-11-17', 'present', NULL, 1, '2025-11-16 02:59:09', '2025-11-16 02:59:09'),
(38, 12, '2025-11-16', 'present', NULL, 1, '2025-11-16 04:55:33', '2025-11-16 06:24:01'),
(39, 13, '2025-11-16', 'present', NULL, 1, '2025-11-16 04:55:33', '2025-11-16 06:24:01'),
(40, 15, '2025-11-16', 'present', NULL, 1, '2025-11-16 04:55:33', '2025-11-16 06:24:01'),
(41, 21, '2025-11-16', 'present', NULL, 1, '2025-11-16 04:55:33', '2025-11-16 06:24:01'),
(42, 26, '2025-11-16', 'present', NULL, 1, '2025-11-16 04:55:33', '2025-11-16 06:24:01'),
(43, 31, '2025-11-16', 'present', NULL, 1, '2025-11-16 04:55:33', '2025-11-16 06:24:01'),
(44, 40, '2025-11-16', 'present', NULL, 1, '2025-11-16 04:55:33', '2025-11-16 06:24:01'),
(45, 43, '2025-11-16', 'present', NULL, 1, '2025-11-16 04:55:33', '2025-11-16 06:24:01'),
(46, 44, '2025-11-16', 'present', NULL, 1, '2025-11-16 04:55:33', '2025-11-16 06:24:01'),
(47, 63, '2025-11-16', 'late', NULL, 1, '2025-11-16 04:55:33', '2025-11-16 06:24:01'),
(48, 80, '2025-11-16', 'present', NULL, 1, '2025-11-16 04:55:33', '2025-11-16 06:24:01'),
(49, 87, '2025-11-16', 'present', NULL, 1, '2025-11-16 04:55:33', '2025-11-16 06:24:01'),
(50, 7, '2025-11-16', 'absent', NULL, 1, '2025-11-16 06:00:03', '2025-11-16 06:00:03'),
(51, 8, '2025-11-16', 'absent', NULL, 1, '2025-11-16 06:00:03', '2025-11-16 06:00:03'),
(52, 24, '2025-11-16', 'absent', NULL, 1, '2025-11-16 06:00:03', '2025-11-16 06:00:03'),
(53, 25, '2025-11-16', 'absent', NULL, 1, '2025-11-16 06:00:03', '2025-11-16 06:00:03'),
(54, 29, '2025-11-16', 'absent', NULL, 1, '2025-11-16 06:00:03', '2025-11-16 06:00:03'),
(55, 50, '2025-11-16', 'absent', NULL, 1, '2025-11-16 06:00:03', '2025-11-16 06:00:03'),
(56, 55, '2025-11-16', 'absent', NULL, 1, '2025-11-16 06:00:03', '2025-11-16 06:00:03'),
(57, 67, '2025-11-16', 'absent', NULL, 1, '2025-11-16 06:00:03', '2025-11-16 06:00:03'),
(58, 70, '2025-11-16', 'absent', NULL, 1, '2025-11-16 06:00:03', '2025-11-16 06:00:03'),
(59, 76, '2025-11-16', 'absent', NULL, 1, '2025-11-16 06:00:03', '2025-11-16 06:00:03'),
(60, 91, '2025-11-16', 'absent', NULL, 1, '2025-11-16 06:00:03', '2025-11-16 06:00:03'),
(61, 98, '2025-11-16', 'absent', NULL, 1, '2025-11-16 06:00:03', '2025-11-16 06:00:03');

-- --------------------------------------------------------

--
-- Table structure for table `cache`
--

CREATE TABLE `cache` (
  `key` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `value` mediumtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `expiration` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `cache_locks`
--

CREATE TABLE `cache_locks` (
  `key` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `owner` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `expiration` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `failed_jobs`
--

CREATE TABLE `failed_jobs` (
  `id` bigint UNSIGNED NOT NULL,
  `uuid` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `connection` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `queue` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `payload` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `exception` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `failed_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `jobs`
--

CREATE TABLE `jobs` (
  `id` bigint UNSIGNED NOT NULL,
  `queue` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `payload` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `attempts` tinyint UNSIGNED NOT NULL,
  `reserved_at` int UNSIGNED DEFAULT NULL,
  `available_at` int UNSIGNED NOT NULL,
  `created_at` int UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `jobs`
--

INSERT INTO `jobs` (`id`, `queue`, `payload`, `attempts`, `reserved_at`, `available_at`, `created_at`) VALUES
(1, 'default', '{\"uuid\":\"439f15c3-eb21-4a30-b3b0-5fff34a70fd5\",\"displayName\":\"App\\\\Events\\\\AttendanceRecorded\",\"job\":\"Illuminate\\\\Queue\\\\CallQueuedHandler@call\",\"maxTries\":null,\"maxExceptions\":null,\"failOnTimeout\":false,\"backoff\":null,\"timeout\":null,\"retryUntil\":null,\"data\":{\"commandName\":\"Illuminate\\\\Broadcasting\\\\BroadcastEvent\",\"command\":\"O:38:\\\"Illuminate\\\\Broadcasting\\\\BroadcastEvent\\\":17:{s:5:\\\"event\\\";O:29:\\\"App\\\\Events\\\\AttendanceRecorded\\\":1:{s:7:\\\"payload\\\";a:1:{s:4:\\\"test\\\";b:1;}}s:5:\\\"tries\\\";N;s:7:\\\"timeout\\\";N;s:7:\\\"backoff\\\";N;s:13:\\\"maxExceptions\\\";N;s:23:\\\"deleteWhenMissingModels\\\";b:1;s:10:\\\"connection\\\";N;s:5:\\\"queue\\\";N;s:12:\\\"messageGroup\\\";N;s:12:\\\"deduplicator\\\";N;s:5:\\\"delay\\\";N;s:11:\\\"afterCommit\\\";N;s:10:\\\"middleware\\\";a:0:{}s:7:\\\"chained\\\";a:0:{}s:15:\\\"chainConnection\\\";N;s:10:\\\"chainQueue\\\";N;s:19:\\\"chainCatchCallbacks\\\";N;}\"},\"createdAt\":1763289518,\"delay\":null}', 0, NULL, 1763289518, 1763289518),
(2, 'default', '{\"uuid\":\"c5903332-a21c-4db8-8645-d2aab8ec4e5e\",\"displayName\":\"App\\\\Events\\\\AttendanceRecorded\",\"job\":\"Illuminate\\\\Queue\\\\CallQueuedHandler@call\",\"maxTries\":null,\"maxExceptions\":null,\"failOnTimeout\":false,\"backoff\":null,\"timeout\":null,\"retryUntil\":null,\"data\":{\"commandName\":\"Illuminate\\\\Broadcasting\\\\BroadcastEvent\",\"command\":\"O:38:\\\"Illuminate\\\\Broadcasting\\\\BroadcastEvent\\\":17:{s:5:\\\"event\\\";O:29:\\\"App\\\\Events\\\\AttendanceRecorded\\\":1:{s:7:\\\"payload\\\";a:4:{s:5:\\\"class\\\";s:1:\\\"8\\\";s:6:\\\"months\\\";a:1:{i:0;s:7:\\\"2025-11\\\";}s:5:\\\"count\\\";i:12;s:6:\\\"sample\\\";a:7:{s:10:\\\"student_id\\\";i:12;s:4:\\\"date\\\";s:10:\\\"2025-11-16\\\";s:6:\\\"status\\\";s:7:\\\"present\\\";s:4:\\\"note\\\";N;s:11:\\\"recorded_by\\\";i:1;s:10:\\\"created_at\\\";O:25:\\\"Illuminate\\\\Support\\\\Carbon\\\":3:{s:4:\\\"date\\\";s:26:\\\"2025-11-16 10:55:33.781900\\\";s:13:\\\"timezone_type\\\";i:3;s:8:\\\"timezone\\\";s:3:\\\"UTC\\\";}s:10:\\\"updated_at\\\";r:14;}}}s:5:\\\"tries\\\";N;s:7:\\\"timeout\\\";N;s:7:\\\"backoff\\\";N;s:13:\\\"maxExceptions\\\";N;s:23:\\\"deleteWhenMissingModels\\\";b:1;s:10:\\\"connection\\\";N;s:5:\\\"queue\\\";N;s:12:\\\"messageGroup\\\";N;s:12:\\\"deduplicator\\\";N;s:5:\\\"delay\\\";N;s:11:\\\"afterCommit\\\";N;s:10:\\\"middleware\\\";a:0:{}s:7:\\\"chained\\\";a:0:{}s:15:\\\"chainConnection\\\";N;s:10:\\\"chainQueue\\\";N;s:19:\\\"chainCatchCallbacks\\\";N;}\"},\"createdAt\":1763290533,\"delay\":null}', 0, NULL, 1763290533, 1763290533),
(3, 'default', '{\"uuid\":\"5790e47f-4ec4-497a-859a-5616bf2e6820\",\"displayName\":\"App\\\\Events\\\\AttendanceRecorded\",\"job\":\"Illuminate\\\\Queue\\\\CallQueuedHandler@call\",\"maxTries\":null,\"maxExceptions\":null,\"failOnTimeout\":false,\"backoff\":null,\"timeout\":null,\"retryUntil\":null,\"data\":{\"commandName\":\"Illuminate\\\\Broadcasting\\\\BroadcastEvent\",\"command\":\"O:38:\\\"Illuminate\\\\Broadcasting\\\\BroadcastEvent\\\":17:{s:5:\\\"event\\\";O:29:\\\"App\\\\Events\\\\AttendanceRecorded\\\":1:{s:7:\\\"payload\\\";a:1:{s:4:\\\"test\\\";b:1;}}s:5:\\\"tries\\\";N;s:7:\\\"timeout\\\";N;s:7:\\\"backoff\\\";N;s:13:\\\"maxExceptions\\\";N;s:23:\\\"deleteWhenMissingModels\\\";b:1;s:10:\\\"connection\\\";N;s:5:\\\"queue\\\";N;s:12:\\\"messageGroup\\\";N;s:12:\\\"deduplicator\\\";N;s:5:\\\"delay\\\";N;s:11:\\\"afterCommit\\\";N;s:10:\\\"middleware\\\";a:0:{}s:7:\\\"chained\\\";a:0:{}s:15:\\\"chainConnection\\\";N;s:10:\\\"chainQueue\\\";N;s:19:\\\"chainCatchCallbacks\\\";N;}\"},\"createdAt\":1763290570,\"delay\":null}', 0, NULL, 1763290570, 1763290570),
(4, 'default', '{\"uuid\":\"91687e48-d728-49a4-8118-97ba628948da\",\"displayName\":\"App\\\\Events\\\\AttendanceRecorded\",\"job\":\"Illuminate\\\\Queue\\\\CallQueuedHandler@call\",\"maxTries\":null,\"maxExceptions\":null,\"failOnTimeout\":false,\"backoff\":null,\"timeout\":null,\"retryUntil\":null,\"data\":{\"commandName\":\"Illuminate\\\\Broadcasting\\\\BroadcastEvent\",\"command\":\"O:38:\\\"Illuminate\\\\Broadcasting\\\\BroadcastEvent\\\":17:{s:5:\\\"event\\\";O:29:\\\"App\\\\Events\\\\AttendanceRecorded\\\":1:{s:7:\\\"payload\\\";a:1:{s:5:\\\"hello\\\";s:5:\\\"world\\\";}}s:5:\\\"tries\\\";N;s:7:\\\"timeout\\\";N;s:7:\\\"backoff\\\";N;s:13:\\\"maxExceptions\\\";N;s:23:\\\"deleteWhenMissingModels\\\";b:1;s:10:\\\"connection\\\";N;s:5:\\\"queue\\\";N;s:12:\\\"messageGroup\\\";N;s:12:\\\"deduplicator\\\";N;s:5:\\\"delay\\\";N;s:11:\\\"afterCommit\\\";N;s:10:\\\"middleware\\\";a:0:{}s:7:\\\"chained\\\";a:0:{}s:15:\\\"chainConnection\\\";N;s:10:\\\"chainQueue\\\";N;s:19:\\\"chainCatchCallbacks\\\";N;}\"},\"createdAt\":1763290646,\"delay\":null}', 0, NULL, 1763290646, 1763290646),
(5, 'default', '{\"uuid\":\"0cd3522b-4cce-4cad-bd56-5d1cbb85e1e4\",\"displayName\":\"App\\\\Events\\\\AttendanceRecorded\",\"job\":\"Illuminate\\\\Queue\\\\CallQueuedHandler@call\",\"maxTries\":null,\"maxExceptions\":null,\"failOnTimeout\":false,\"backoff\":null,\"timeout\":null,\"retryUntil\":null,\"data\":{\"commandName\":\"Illuminate\\\\Broadcasting\\\\BroadcastEvent\",\"command\":\"O:38:\\\"Illuminate\\\\Broadcasting\\\\BroadcastEvent\\\":17:{s:5:\\\"event\\\";O:29:\\\"App\\\\Events\\\\AttendanceRecorded\\\":1:{s:7:\\\"payload\\\";a:4:{s:5:\\\"class\\\";s:1:\\\"7\\\";s:6:\\\"months\\\";a:1:{i:0;s:7:\\\"2025-11\\\";}s:5:\\\"count\\\";i:12;s:6:\\\"sample\\\";a:7:{s:10:\\\"student_id\\\";i:7;s:4:\\\"date\\\";s:10:\\\"2025-11-16\\\";s:6:\\\"status\\\";s:6:\\\"absent\\\";s:4:\\\"note\\\";N;s:11:\\\"recorded_by\\\";i:1;s:10:\\\"created_at\\\";O:25:\\\"Illuminate\\\\Support\\\\Carbon\\\":3:{s:4:\\\"date\\\";s:26:\\\"2025-11-16 12:00:03.006524\\\";s:13:\\\"timezone_type\\\";i:3;s:8:\\\"timezone\\\";s:3:\\\"UTC\\\";}s:10:\\\"updated_at\\\";r:14;}}}s:5:\\\"tries\\\";N;s:7:\\\"timeout\\\";N;s:7:\\\"backoff\\\";N;s:13:\\\"maxExceptions\\\";N;s:23:\\\"deleteWhenMissingModels\\\";b:1;s:10:\\\"connection\\\";N;s:5:\\\"queue\\\";N;s:12:\\\"messageGroup\\\";N;s:12:\\\"deduplicator\\\";N;s:5:\\\"delay\\\";N;s:11:\\\"afterCommit\\\";N;s:10:\\\"middleware\\\";a:0:{}s:7:\\\"chained\\\";a:0:{}s:15:\\\"chainConnection\\\";N;s:10:\\\"chainQueue\\\";N;s:19:\\\"chainCatchCallbacks\\\";N;}\"},\"createdAt\":1763294403,\"delay\":null}', 0, NULL, 1763294403, 1763294403),
(6, 'default', '{\"uuid\":\"ee549901-7e10-4277-b138-5207190ace8c\",\"displayName\":\"App\\\\Events\\\\AttendanceRecorded\",\"job\":\"Illuminate\\\\Queue\\\\CallQueuedHandler@call\",\"maxTries\":null,\"maxExceptions\":null,\"failOnTimeout\":false,\"backoff\":null,\"timeout\":null,\"retryUntil\":null,\"data\":{\"commandName\":\"Illuminate\\\\Broadcasting\\\\BroadcastEvent\",\"command\":\"O:38:\\\"Illuminate\\\\Broadcasting\\\\BroadcastEvent\\\":17:{s:5:\\\"event\\\";O:29:\\\"App\\\\Events\\\\AttendanceRecorded\\\":1:{s:7:\\\"payload\\\";a:4:{s:5:\\\"class\\\";s:1:\\\"8\\\";s:6:\\\"months\\\";a:1:{i:0;s:7:\\\"2025-11\\\";}s:5:\\\"count\\\";i:12;s:6:\\\"sample\\\";a:7:{s:10:\\\"student_id\\\";i:12;s:4:\\\"date\\\";s:10:\\\"2025-11-16\\\";s:6:\\\"status\\\";s:7:\\\"present\\\";s:4:\\\"note\\\";N;s:11:\\\"recorded_by\\\";i:1;s:10:\\\"created_at\\\";O:25:\\\"Illuminate\\\\Support\\\\Carbon\\\":3:{s:4:\\\"date\\\";s:26:\\\"2025-11-16 12:10:51.620765\\\";s:13:\\\"timezone_type\\\";i:3;s:8:\\\"timezone\\\";s:3:\\\"UTC\\\";}s:10:\\\"updated_at\\\";r:14;}}}s:5:\\\"tries\\\";N;s:7:\\\"timeout\\\";N;s:7:\\\"backoff\\\";N;s:13:\\\"maxExceptions\\\";N;s:23:\\\"deleteWhenMissingModels\\\";b:1;s:10:\\\"connection\\\";N;s:5:\\\"queue\\\";N;s:12:\\\"messageGroup\\\";N;s:12:\\\"deduplicator\\\";N;s:5:\\\"delay\\\";N;s:11:\\\"afterCommit\\\";N;s:10:\\\"middleware\\\";a:0:{}s:7:\\\"chained\\\";a:0:{}s:15:\\\"chainConnection\\\";N;s:10:\\\"chainQueue\\\";N;s:19:\\\"chainCatchCallbacks\\\";N;}\"},\"createdAt\":1763295051,\"delay\":null}', 0, NULL, 1763295051, 1763295051),
(7, 'default', '{\"uuid\":\"17e0084e-15ce-4cfa-80da-60dd7973a39f\",\"displayName\":\"App\\\\Events\\\\AttendanceRecorded\",\"job\":\"Illuminate\\\\Queue\\\\CallQueuedHandler@call\",\"maxTries\":null,\"maxExceptions\":null,\"failOnTimeout\":false,\"backoff\":null,\"timeout\":null,\"retryUntil\":null,\"data\":{\"commandName\":\"Illuminate\\\\Broadcasting\\\\BroadcastEvent\",\"command\":\"O:38:\\\"Illuminate\\\\Broadcasting\\\\BroadcastEvent\\\":17:{s:5:\\\"event\\\";O:29:\\\"App\\\\Events\\\\AttendanceRecorded\\\":1:{s:7:\\\"payload\\\";a:4:{s:5:\\\"class\\\";s:1:\\\"8\\\";s:6:\\\"months\\\";a:1:{i:0;s:7:\\\"2025-11\\\";}s:5:\\\"count\\\";i:12;s:6:\\\"sample\\\";a:7:{s:10:\\\"student_id\\\";i:12;s:4:\\\"date\\\";s:10:\\\"2025-11-16\\\";s:6:\\\"status\\\";s:6:\\\"absent\\\";s:4:\\\"note\\\";N;s:11:\\\"recorded_by\\\";i:1;s:10:\\\"created_at\\\";O:25:\\\"Illuminate\\\\Support\\\\Carbon\\\":3:{s:4:\\\"date\\\";s:26:\\\"2025-11-16 12:11:25.878584\\\";s:13:\\\"timezone_type\\\";i:3;s:8:\\\"timezone\\\";s:3:\\\"UTC\\\";}s:10:\\\"updated_at\\\";r:14;}}}s:5:\\\"tries\\\";N;s:7:\\\"timeout\\\";N;s:7:\\\"backoff\\\";N;s:13:\\\"maxExceptions\\\";N;s:23:\\\"deleteWhenMissingModels\\\";b:1;s:10:\\\"connection\\\";N;s:5:\\\"queue\\\";N;s:12:\\\"messageGroup\\\";N;s:12:\\\"deduplicator\\\";N;s:5:\\\"delay\\\";N;s:11:\\\"afterCommit\\\";N;s:10:\\\"middleware\\\";a:0:{}s:7:\\\"chained\\\";a:0:{}s:15:\\\"chainConnection\\\";N;s:10:\\\"chainQueue\\\";N;s:19:\\\"chainCatchCallbacks\\\";N;}\"},\"createdAt\":1763295085,\"delay\":null}', 0, NULL, 1763295085, 1763295085);

-- --------------------------------------------------------

--
-- Table structure for table `job_batches`
--

CREATE TABLE `job_batches` (
  `id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `total_jobs` int NOT NULL,
  `pending_jobs` int NOT NULL,
  `failed_jobs` int NOT NULL,
  `failed_job_ids` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `options` mediumtext COLLATE utf8mb4_unicode_ci,
  `cancelled_at` int DEFAULT NULL,
  `created_at` int NOT NULL,
  `finished_at` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `migrations`
--

CREATE TABLE `migrations` (
  `id` int UNSIGNED NOT NULL,
  `migration` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `batch` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `migrations`
--

INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES
(1, '0001_01_01_000000_create_users_table', 1),
(2, '0001_01_01_000001_create_cache_table', 1),
(3, '0001_01_01_000002_create_jobs_table', 1),
(4, '2025_11_15_050915_create_personal_access_tokens_table', 1),
(5, '2025_11_15_054549_create_students_table', 1),
(6, '2025_11_15_064819_create_attendances_table', 1);

-- --------------------------------------------------------

--
-- Table structure for table `password_reset_tokens`
--

CREATE TABLE `password_reset_tokens` (
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `token` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `personal_access_tokens`
--

CREATE TABLE `personal_access_tokens` (
  `id` bigint UNSIGNED NOT NULL,
  `tokenable_type` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `tokenable_id` bigint UNSIGNED NOT NULL,
  `name` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `token` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL,
  `abilities` text COLLATE utf8mb4_unicode_ci,
  `last_used_at` timestamp NULL DEFAULT NULL,
  `expires_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `personal_access_tokens`
--

INSERT INTO `personal_access_tokens` (`id`, `tokenable_type`, `tokenable_id`, `name`, `token`, `abilities`, `last_used_at`, `expires_at`, `created_at`, `updated_at`) VALUES
(2, 'App\\Models\\User', 1, 'web', 'fb1ea5bef364fd4e8f4cd04c15a92a8a864c610b43114ceb3d52750b28928048', '[\"*\"]', '2025-11-16 06:24:01', NULL, '2025-11-16 04:55:25', '2025-11-16 06:24:01'),
(3, 'App\\Models\\User', 1, 'web', 'c9a09a7c2c1908849b95866fcb90614ad30898e80fa4bb8450ba936e26f1143a', '[\"*\"]', '2025-11-16 06:17:44', NULL, '2025-11-16 05:22:46', '2025-11-16 06:17:44');

-- --------------------------------------------------------

--
-- Table structure for table `sessions`
--

CREATE TABLE `sessions` (
  `id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_id` bigint UNSIGNED DEFAULT NULL,
  `ip_address` varchar(45) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `user_agent` text COLLATE utf8mb4_unicode_ci,
  `payload` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `last_activity` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `sessions`
--

INSERT INTO `sessions` (`id`, `user_id`, `ip_address`, `user_agent`, `payload`, `last_activity`) VALUES
('6dRIG42TEgNEBu4wKHYmeoPbSkYFw9Qc25w4nBGo', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36 Edg/142.0.0.0', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiUHNYdHJhT2Z0Wm0xRndtSFNvcFB5N0lLUGlxQkhOanpmalJyMTNZTyI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJuZXciO2E6MDp7fXM6Mzoib2xkIjthOjA6e319czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mzc6Imh0dHA6Ly9taW5pLWF0dGVuZGFuY2UudGVzdC9kYXNoYm9hcmQiO3M6NToicm91dGUiO047fX0=', 1763295463),
('86Xd1ISwJfG7XyM9rcGFBcUtRxLfqUhNKyUrgT1G', NULL, '127.0.0.1', 'curl/8.11.0', 'YToyOntzOjY6Il90b2tlbiI7czo0MDoiSlNPRzBLS2k2REJpa2wzNlVvOGhZbHgxa3YyOFlSUmVwc1luMHd2QyI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJuZXciO2E6MDp7fXM6Mzoib2xkIjthOjA6e319fQ==', 1763291834),
('FXifGyQHAlbn6pZMAMKAv9sCrQu0uDJLRvv3Px7R', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiOVFIWUs4aDhvQ2ZBcGtBUmloWFFQcUZTWTFnendGNDRBQUpRY2lCYyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mzg6Imh0dHA6Ly9taW5pLWF0dGVuZGFuY2UudGVzdC9hdHRlbmRhbmNlIjtzOjU6InJvdXRlIjtOO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19', 1763294553),
('tFcOXoOX09G41SyRNQqv0bj06FYVUgFe5uBR8J3d', NULL, '127.0.0.1', 'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Mobile Safari/537.36 Edg/142.0.0.0', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiV2VMT1ZxNTN1b2Z0VWI4VkcyWmNWcHMyYTlOTTZGUEpXN2w2ck9yUSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mzc6Imh0dHA6Ly9taW5pLWF0dGVuZGFuY2UudGVzdC9kYXNoYm9hcmQiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1763291936);

-- --------------------------------------------------------

--
-- Table structure for table `students`
--

CREATE TABLE `students` (
  `id` bigint UNSIGNED NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `student_id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `class` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `section` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `photo` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `students`
--

INSERT INTO `students` (`id`, `name`, `student_id`, `class`, `section`, `photo`, `created_at`, `updated_at`) VALUES
(1, 'Kaya Hartmann', 'S-5988', '7', 'C', NULL, '2025-11-15 23:46:14', '2025-11-15 23:46:14'),
(2, 'Clemmie Zulauf I', 'S-9178', '10', 'A', NULL, '2025-11-15 23:46:14', '2025-11-15 23:46:14'),
(3, 'Kennedy Becker', 'S-1704', '7', 'C', NULL, '2025-11-15 23:46:14', '2025-11-15 23:46:14'),
(4, 'Dr. Brain Braun', 'S-7826', '9', 'A', NULL, '2025-11-15 23:46:14', '2025-11-15 23:46:14'),
(5, 'Camille Trantow Sr.', 'S-4803', '9', 'A', NULL, '2025-11-15 23:46:14', '2025-11-15 23:46:14'),
(6, 'Mr. Gillian Wisoky Jr.', 'S-3822', '8', 'B', NULL, '2025-11-15 23:46:14', '2025-11-15 23:46:14'),
(7, 'Garth Kirlin', 'S-2373', '7', 'B', NULL, '2025-11-15 23:46:14', '2025-11-15 23:46:14'),
(8, 'Davin Koepp', 'S-9445', '7', 'C', NULL, '2025-11-15 23:46:14', '2025-11-15 23:46:14'),
(9, 'Brayan Hagenes', 'S-8595', '9', 'A', NULL, '2025-11-15 23:46:14', '2025-11-15 23:46:14'),
(10, 'Corrine Barton', 'S-3995', '6', 'A', NULL, '2025-11-15 23:46:14', '2025-11-15 23:46:14'),
(11, 'Francisco Lind', 'S-5579', '10', 'C', NULL, '2025-11-15 23:46:14', '2025-11-15 23:46:14'),
(12, 'Bettye Ryan', 'S-3130', '8', 'C', NULL, '2025-11-15 23:46:14', '2025-11-15 23:46:14'),
(13, 'Alfredo Reilly IV', 'S-1583', '8', 'B', NULL, '2025-11-15 23:46:14', '2025-11-15 23:46:14'),
(14, 'Vida Cummerata', 'S-3313', '7', 'B', NULL, '2025-11-15 23:46:14', '2025-11-15 23:46:14'),
(15, 'Ezekiel Kunde', 'S-6897', '8', 'A', NULL, '2025-11-15 23:46:14', '2025-11-15 23:46:14'),
(16, 'Green Shields', 'S-2298', '10', 'B', NULL, '2025-11-15 23:46:14', '2025-11-15 23:46:14'),
(17, 'Lorenzo Parisian', 'S-7834', '7', 'C', NULL, '2025-11-15 23:46:14', '2025-11-15 23:46:14'),
(18, 'Paul Nikolaus', 'S-7445', '9', 'C', NULL, '2025-11-15 23:46:14', '2025-11-15 23:46:14'),
(19, 'Olaf Hudson', 'S-7132', '9', 'C', NULL, '2025-11-15 23:46:14', '2025-11-15 23:46:14'),
(20, 'Karina Carter', 'S-1277', '10', 'B', NULL, '2025-11-15 23:46:14', '2025-11-15 23:46:14'),
(21, 'Jose Johnston', 'S-7967', '8', 'B', NULL, '2025-11-15 23:46:14', '2025-11-15 23:46:14'),
(22, 'Prof. Torrance Hahn I', 'S-6968', '7', 'B', NULL, '2025-11-15 23:46:14', '2025-11-15 23:46:14'),
(23, 'Donna Rogahn', 'S-1838', '9', 'B', NULL, '2025-11-15 23:46:14', '2025-11-15 23:46:14'),
(24, 'Abner Rosenbaum', 'S-3428', '7', 'C', NULL, '2025-11-15 23:46:14', '2025-11-15 23:46:14'),
(25, 'Dr. Reba Hettinger', 'S-9619', '7', 'C', NULL, '2025-11-15 23:46:14', '2025-11-15 23:46:14'),
(26, 'Kaley Ziemann', 'S-8929', '8', 'C', NULL, '2025-11-15 23:46:14', '2025-11-15 23:46:14'),
(27, 'Dr. Effie Hintz III', 'S-5897', '6', 'B', NULL, '2025-11-15 23:46:14', '2025-11-15 23:46:14'),
(28, 'Albin Rempel', 'S-4344', '10', 'C', NULL, '2025-11-15 23:46:14', '2025-11-15 23:46:14'),
(29, 'Katherine Jaskolski Sr.', 'S-9106', '7', 'A', NULL, '2025-11-15 23:46:14', '2025-11-15 23:46:14'),
(30, 'Dr. Estelle Stoltenberg MD', 'S-9268', '9', 'C', NULL, '2025-11-15 23:46:14', '2025-11-15 23:46:14'),
(31, 'Mr. German Herzog DDS', 'S-2790', '8', 'B', NULL, '2025-11-15 23:46:14', '2025-11-15 23:46:14'),
(32, 'Mr. Dino Runte', 'S-3941', '9', 'B', NULL, '2025-11-15 23:46:14', '2025-11-15 23:46:14'),
(33, 'Rosemarie Bogisich', 'S-7597', '9', 'C', NULL, '2025-11-15 23:46:14', '2025-11-15 23:46:14'),
(34, 'Trystan Nader', 'S-8393', '9', 'C', NULL, '2025-11-15 23:46:14', '2025-11-15 23:46:14'),
(35, 'Ms. Rosalee Parker', 'S-5627', '10', 'C', NULL, '2025-11-15 23:46:14', '2025-11-15 23:46:14'),
(36, 'Miss Beth Olson', 'S-7089', '6', 'B', NULL, '2025-11-15 23:46:14', '2025-11-15 23:46:14'),
(37, 'Mr. Wayne Senger IV', 'S-4070', '10', 'A', NULL, '2025-11-15 23:46:14', '2025-11-15 23:46:14'),
(38, 'Roselyn Huel', 'S-3583', '8', 'B', NULL, '2025-11-15 23:46:14', '2025-11-15 23:46:14'),
(39, 'Prof. Camilla Beahan', 'S-4942', '6', 'A', NULL, '2025-11-15 23:46:14', '2025-11-15 23:46:14'),
(40, 'Janie Lynch Jr.', 'S-2827', '8', 'C', NULL, '2025-11-15 23:46:14', '2025-11-15 23:46:14'),
(41, 'Mallie Russel', 'S-4302', '7', 'C', NULL, '2025-11-15 23:46:14', '2025-11-15 23:46:14'),
(42, 'Stacy Berge', 'S-9967', '6', 'B', NULL, '2025-11-15 23:46:14', '2025-11-15 23:46:14'),
(43, 'Loraine Goldner', 'S-7271', '8', 'C', NULL, '2025-11-15 23:46:14', '2025-11-15 23:46:14'),
(44, 'Ana Bosco', 'S-5711', '8', 'B', NULL, '2025-11-15 23:46:14', '2025-11-15 23:46:14'),
(45, 'Lucius Collins', 'S-8586', '9', 'A', NULL, '2025-11-15 23:46:14', '2025-11-15 23:46:14'),
(46, 'Fanny Parisian', 'S-9949', '9', 'B', NULL, '2025-11-15 23:46:14', '2025-11-15 23:46:14'),
(47, 'Mack Lynch', 'S-5643', '9', 'A', NULL, '2025-11-15 23:46:14', '2025-11-15 23:46:14'),
(48, 'Ms. Shawna Lakin', 'S-3196', '8', 'B', NULL, '2025-11-15 23:46:14', '2025-11-15 23:46:14'),
(49, 'Dr. Freeman Pfannerstill', 'S-4146', '9', 'B', NULL, '2025-11-15 23:46:14', '2025-11-15 23:46:14'),
(50, 'Johnny Schuppe', 'S-9403', '7', 'C', NULL, '2025-11-15 23:46:14', '2025-11-15 23:46:14'),
(51, 'Kade Reichert', 'S-3748', '6', 'C', NULL, '2025-11-15 23:46:14', '2025-11-15 23:46:14'),
(52, 'Orrin Waelchi', 'S-9870', '10', 'C', NULL, '2025-11-15 23:46:14', '2025-11-15 23:46:14'),
(53, 'Bennie Kovacek', 'S-3545', '6', 'C', NULL, '2025-11-15 23:46:14', '2025-11-15 23:46:14'),
(54, 'Modesta Ferry', 'S-5717', '9', 'A', NULL, '2025-11-15 23:46:14', '2025-11-15 23:46:14'),
(55, 'Annabelle Berge', 'S-3240', '7', 'B', NULL, '2025-11-15 23:46:14', '2025-11-15 23:46:14'),
(56, 'Prof. Kevon Brown Jr.', 'S-2485', '7', 'A', NULL, '2025-11-15 23:46:14', '2025-11-15 23:46:14'),
(57, 'Kyleigh Ebert', 'S-4595', '7', 'A', NULL, '2025-11-15 23:46:14', '2025-11-15 23:46:14'),
(58, 'Dr. Joelle Lindgren', 'S-2277', '10', 'A', NULL, '2025-11-15 23:46:14', '2025-11-15 23:46:14'),
(59, 'Sheldon VonRueden', 'S-4306', '6', 'A', NULL, '2025-11-15 23:46:14', '2025-11-15 23:46:14'),
(60, 'Sally Johns II', 'S-3759', '9', 'A', NULL, '2025-11-15 23:46:14', '2025-11-15 23:46:14'),
(61, 'Melisa Hintz Jr.', 'S-4044', '6', 'B', NULL, '2025-11-15 23:46:14', '2025-11-15 23:46:14'),
(62, 'Mr. Kareem Schiller MD', 'S-1653', '7', 'C', NULL, '2025-11-15 23:46:14', '2025-11-15 23:46:14'),
(63, 'Ahmed Wisozk', 'S-8170', '8', 'B', NULL, '2025-11-15 23:46:14', '2025-11-15 23:46:14'),
(64, 'Nels Collins', 'S-5556', '7', 'B', NULL, '2025-11-15 23:46:14', '2025-11-15 23:46:14'),
(65, 'Westley Kirlin', 'S-4812', '9', 'A', NULL, '2025-11-15 23:46:14', '2025-11-15 23:46:14'),
(66, 'Ruben Haley', 'S-6227', '10', 'A', NULL, '2025-11-15 23:46:14', '2025-11-15 23:46:14'),
(67, 'Colton Johns', 'S-2639', '7', 'A', NULL, '2025-11-15 23:46:14', '2025-11-15 23:46:14'),
(68, 'Rosanna Muller', 'S-1124', '9', 'A', NULL, '2025-11-15 23:46:14', '2025-11-15 23:46:14'),
(69, 'Mrs. Jazmyn Jenkins', 'S-9055', '10', 'A', NULL, '2025-11-15 23:46:14', '2025-11-15 23:46:14'),
(70, 'Bridget Rohan Jr.', 'S-5618', '7', 'B', NULL, '2025-11-15 23:46:14', '2025-11-15 23:46:14'),
(71, 'Magali Bernier', 'S-4029', '7', 'C', NULL, '2025-11-15 23:46:14', '2025-11-15 23:46:14'),
(72, 'Nova VonRueden', 'S-8166', '7', 'C', NULL, '2025-11-15 23:46:14', '2025-11-15 23:46:14'),
(73, 'Mrs. Kaylee Smitham', 'S-1350', '10', 'B', NULL, '2025-11-15 23:46:14', '2025-11-15 23:46:14'),
(74, 'Roel Keebler', 'S-9802', '8', 'A', NULL, '2025-11-15 23:46:14', '2025-11-15 23:46:14'),
(75, 'Mr. Miller Ratke', 'S-6524', '8', 'B', NULL, '2025-11-15 23:46:14', '2025-11-15 23:46:14'),
(76, 'Arely Kuhic', 'S-4726', '7', 'B', NULL, '2025-11-15 23:46:14', '2025-11-15 23:46:14'),
(77, 'Forrest Hartmann', 'S-2987', '6', 'A', NULL, '2025-11-15 23:46:14', '2025-11-15 23:46:14'),
(78, 'Mr. Jaren Reichel', 'S-6552', '6', 'B', NULL, '2025-11-15 23:46:14', '2025-11-15 23:46:14'),
(79, 'Sammy Brakus', 'S-5787', '9', 'A', NULL, '2025-11-15 23:46:14', '2025-11-15 23:46:14'),
(80, 'Jailyn Langworth', 'S-6687', '8', 'C', NULL, '2025-11-15 23:46:14', '2025-11-15 23:46:14'),
(81, 'Ms. Jennyfer Schultz PhD', 'S-1049', '6', 'C', NULL, '2025-11-15 23:46:14', '2025-11-15 23:46:14'),
(82, 'Mr. Jonathan Greenfelder', 'S-5350', '7', 'C', NULL, '2025-11-15 23:46:14', '2025-11-15 23:46:14'),
(83, 'Will Walsh', 'S-2931', '7', 'C', NULL, '2025-11-15 23:46:14', '2025-11-15 23:46:14'),
(84, 'Dr. Libby Stokes Jr.', 'S-7775', '6', 'A', NULL, '2025-11-15 23:46:14', '2025-11-15 23:46:14'),
(85, 'Lera Yost', 'S-5337', '10', 'A', NULL, '2025-11-15 23:46:14', '2025-11-15 23:46:14'),
(86, 'Miss Audreanne Mann', 'S-9070', '7', 'C', NULL, '2025-11-15 23:46:14', '2025-11-15 23:46:14'),
(87, 'Imogene Douglas', 'S-1927', '8', 'B', NULL, '2025-11-15 23:46:14', '2025-11-15 23:46:14'),
(88, 'Kiarra Volkman', 'S-5630', '6', 'B', NULL, '2025-11-15 23:46:14', '2025-11-15 23:46:14'),
(89, 'Dr. Americo Rippin V', 'S-9588', '6', 'B', NULL, '2025-11-15 23:46:14', '2025-11-15 23:46:14'),
(90, 'Hilma Pollich', 'S-6317', '9', 'C', NULL, '2025-11-15 23:46:14', '2025-11-15 23:46:14'),
(91, 'Agustina Schiller', 'S-8036', '7', 'B', NULL, '2025-11-15 23:46:14', '2025-11-15 23:46:14'),
(92, 'Clair Reichel', 'S-5769', '10', 'B', NULL, '2025-11-15 23:46:14', '2025-11-15 23:46:14'),
(93, 'Mr. Darryl McDermott PhD', 'S-1536', '9', 'B', NULL, '2025-11-15 23:46:14', '2025-11-15 23:46:14'),
(94, 'Mr. Brady Schaefer Sr.', 'S-1110', '6', 'C', NULL, '2025-11-15 23:46:14', '2025-11-15 23:46:14'),
(95, 'Rosalinda Volkman', 'S-1874', '6', 'C', NULL, '2025-11-15 23:46:14', '2025-11-15 23:46:14'),
(96, 'Mr. Misael Torp II', 'S-6790', '8', 'C', NULL, '2025-11-15 23:46:14', '2025-11-15 23:46:14'),
(97, 'Mr. Sebastian Gibson DDS', 'S-7506', '10', 'A', NULL, '2025-11-15 23:46:14', '2025-11-15 23:46:14'),
(98, 'Cecilia Kemmer', 'S-2548', '7', 'C', NULL, '2025-11-15 23:46:14', '2025-11-15 23:46:14'),
(99, 'Kavon Bernier', 'S-7088', '6', 'C', NULL, '2025-11-15 23:46:14', '2025-11-15 23:46:14'),
(100, 'Leopold Fisher', 'S-9576', '7', 'B', NULL, '2025-11-15 23:46:14', '2025-11-15 23:46:14');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` bigint UNSIGNED NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `password` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `remember_token` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `name`, `email`, `email_verified_at`, `password`, `remember_token`, `created_at`, `updated_at`) VALUES
(1, 'Admin', 'admin@example.com', NULL, '$2y$12$4saDCQrCkVSAhbiTjEkTien4POTMEslq6eHOzxvL.MfLuHWJUvZSW', NULL, '2025-11-15 23:44:22', '2025-11-15 23:44:22');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `attendances`
--
ALTER TABLE `attendances`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `attendances_student_id_date_unique` (`student_id`,`date`),
  ADD KEY `attendances_recorded_by_foreign` (`recorded_by`);

--
-- Indexes for table `cache`
--
ALTER TABLE `cache`
  ADD PRIMARY KEY (`key`);

--
-- Indexes for table `cache_locks`
--
ALTER TABLE `cache_locks`
  ADD PRIMARY KEY (`key`);

--
-- Indexes for table `failed_jobs`
--
ALTER TABLE `failed_jobs`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `failed_jobs_uuid_unique` (`uuid`);

--
-- Indexes for table `jobs`
--
ALTER TABLE `jobs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `jobs_queue_index` (`queue`);

--
-- Indexes for table `job_batches`
--
ALTER TABLE `job_batches`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `migrations`
--
ALTER TABLE `migrations`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `password_reset_tokens`
--
ALTER TABLE `password_reset_tokens`
  ADD PRIMARY KEY (`email`);

--
-- Indexes for table `personal_access_tokens`
--
ALTER TABLE `personal_access_tokens`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `personal_access_tokens_token_unique` (`token`),
  ADD KEY `personal_access_tokens_tokenable_type_tokenable_id_index` (`tokenable_type`,`tokenable_id`),
  ADD KEY `personal_access_tokens_expires_at_index` (`expires_at`);

--
-- Indexes for table `sessions`
--
ALTER TABLE `sessions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `sessions_user_id_index` (`user_id`),
  ADD KEY `sessions_last_activity_index` (`last_activity`);

--
-- Indexes for table `students`
--
ALTER TABLE `students`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `students_student_id_unique` (`student_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `users_email_unique` (`email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `attendances`
--
ALTER TABLE `attendances`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=134;

--
-- AUTO_INCREMENT for table `failed_jobs`
--
ALTER TABLE `failed_jobs`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `jobs`
--
ALTER TABLE `jobs`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `migrations`
--
ALTER TABLE `migrations`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `personal_access_tokens`
--
ALTER TABLE `personal_access_tokens`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `students`
--
ALTER TABLE `students`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=101;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `attendances`
--
ALTER TABLE `attendances`
  ADD CONSTRAINT `attendances_recorded_by_foreign` FOREIGN KEY (`recorded_by`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `attendances_student_id_foreign` FOREIGN KEY (`student_id`) REFERENCES `students` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

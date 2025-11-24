-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Máy chủ: 127.0.0.1
-- Thời gian đã tạo: Th10 15, 2025 lúc 05:28 PM
-- Phiên bản máy phục vụ: 10.4.32-MariaDB
-- Phiên bản PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Cơ sở dữ liệu: `kmeans`
--

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `jobs`
--

CREATE TABLE `jobs` (
  `id` bigint(20) NOT NULL,
  `user_id` bigint(20) NOT NULL,
  `type` enum('IMAGE') NOT NULL DEFAULT 'IMAGE',
  `k` int(11) NOT NULL,
  `status` varchar(50) NOT NULL,
  `duration_ms` bigint(20) DEFAULT 0,
  `error_message` text DEFAULT NULL,
  `input_path` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `jobs`
--

INSERT INTO `jobs` (`id`, `user_id`, `type`, `k`, `status`, `duration_ms`, `error_message`, `input_path`, `created_at`) VALUES
(1, 1, 'IMAGE', 50, 'PENDING', 0, NULL, NULL, '2025-11-11 06:31:25'),
(2, 1, 'IMAGE', 8, 'DONE', 75462, NULL, NULL, '2025-11-11 06:37:10'),
(3, 1, 'IMAGE', 5, 'DONE', 1059, NULL, NULL, '2025-11-13 16:08:03'),
(4, 1, 'IMAGE', 5, 'DONE', 977, NULL, NULL, '2025-11-13 16:19:34'),
(5, 1, 'IMAGE', 5, 'DONE', 1053, NULL, NULL, '2025-11-15 03:16:18'),
(6, 1, 'IMAGE', 5, 'DONE', 5370, NULL, NULL, '2025-11-15 03:21:24'),
(7, 1, 'IMAGE', 32, 'DONE', 187977, NULL, NULL, '2025-11-15 12:01:48'),
(8, 1, 'IMAGE', 30, 'DONE', 171886, NULL, NULL, '2025-11-15 12:07:13'),
(9, 1, 'IMAGE', 50, 'DONE', 8275, NULL, NULL, '2025-11-15 12:13:33'),
(10, 1, 'IMAGE', 30, 'DONE', 242816, NULL, NULL, '2025-11-15 12:25:07');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `results`
--

CREATE TABLE `results` (
  `id` bigint(20) NOT NULL,
  `job_id` bigint(20) NOT NULL,
  `output_rel_path` text NOT NULL,
  `width` int(11) NOT NULL,
  `height` int(11) NOT NULL,
  `n_points` int(11) NOT NULL,
  `summary` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `results`
--

INSERT INTO `results` (`id`, `job_id`, `output_rel_path`, `width`, `height`, `n_points`, `summary`, `created_at`) VALUES
(1, 2, 'u-1/image-result-2.png', 1414, 2000, 2828000, 'K=8, 1414x2000, iters=78', '2025-11-11 06:38:26'),
(2, 3, 'u-1/image-result-3.png', 331, 319, 105589, 'K=5, 331x319, iters=44', '2025-11-13 16:08:04'),
(3, 4, 'u-1/image-result-4.png', 331, 319, 105589, 'K=5, 331x319, iters=46', '2025-11-13 16:19:36'),
(4, 5, 'D:/Eclipse/eclipse/workspace/.metadata/.plugins/org.eclipse.wst.server.core/tmp0/kmeans-data/u-1/image-result-5.png', 331, 319, 105589, 'K=5, 331x319, iters=51', '2025-11-15 03:16:19'),
(5, 6, 'D:/kmeans-data/u-1/image-result-6.png', 1920, 1380, 2649600, 'K=5, 1920x1380, iters=10', '2025-11-15 03:21:30'),
(6, 7, 'D:/kmeans-data/u-1/image-result-7.png', 3840, 2160, 8294400, 'K=32, 3840x2160, iters=100', '2025-11-15 12:04:56'),
(7, 8, 'D:/kmeans-data/u-1/image-result-8.png', 3840, 2160, 8294400, 'K=30, 3840x2160, iters=100', '2025-11-15 12:10:05'),
(8, 9, 'D:/kmeans-data/u-1/image-result-9.png', 1920, 1380, 2649600, 'K=50, 1920x1380, iters=11', '2025-11-15 12:13:41'),
(9, 10, 'D:/kmeans-data/u-1/image-result-10.png', 3840, 2760, 10598400, 'K=30, 3840x2760, iters=100', '2025-11-15 12:29:10');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `users`
--

CREATE TABLE `users` (
  `id` bigint(20) NOT NULL,
  `email` varchar(255) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `role` enum('USER','ADMIN') NOT NULL DEFAULT 'USER',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `users`
--

INSERT INTO `users` (`id`, `email`, `password_hash`, `role`, `created_at`) VALUES
(1, 'abc@gmail.com', '123', 'USER', '2025-11-11 06:20:42');

--
-- Chỉ mục cho các bảng đã đổ
--

--
-- Chỉ mục cho bảng `jobs`
--
ALTER TABLE `jobs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_jobs_users` (`user_id`);

--
-- Chỉ mục cho bảng `results`
--
ALTER TABLE `results`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_results_jobs` (`job_id`);

--
-- Chỉ mục cho bảng `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- AUTO_INCREMENT cho các bảng đã đổ
--

--
-- AUTO_INCREMENT cho bảng `jobs`
--
ALTER TABLE `jobs`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT cho bảng `results`
--
ALTER TABLE `results`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT cho bảng `users`
--
ALTER TABLE `users`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- Các ràng buộc cho các bảng đã đổ
--

--
-- Các ràng buộc cho bảng `jobs`
--
ALTER TABLE `jobs`
  ADD CONSTRAINT `fk_jobs_users` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Các ràng buộc cho bảng `results`
--
ALTER TABLE `results`
  ADD CONSTRAINT `fk_results_jobs` FOREIGN KEY (`job_id`) REFERENCES `jobs` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1:3308
-- Generation Time: Oct 21, 2024 at 05:06 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `library`
--

-- --------------------------------------------------------

--
-- Table structure for table `authors`
--

CREATE TABLE `authors` (
  `authorid` int(9) NOT NULL,
  `name` char(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `authors`
--

INSERT INTO `authors` (`authorid`, `name`) VALUES
(108, 'J.K. Rowling'),
(109, 'Gale');

-- --------------------------------------------------------

--
-- Table structure for table `books`
--

CREATE TABLE `books` (
  `bookid` int(9) NOT NULL,
  `title` char(255) NOT NULL,
  `authorid` int(9) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `books`
--

INSERT INTO `books` (`bookid`, `title`, `authorid`) VALUES
(154, 'Math', 109),
(155, '1984', 109);

-- --------------------------------------------------------

--
-- Table structure for table `books_authors`
--

CREATE TABLE `books_authors` (
  `collectionid` int(9) NOT NULL,
  `bookid` int(9) NOT NULL,
  `authorid` int(9) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `books_authors`
--

INSERT INTO `books_authors` (`collectionid`, `bookid`, `authorid`) VALUES
(107, 154, 109);

-- --------------------------------------------------------

--
-- Table structure for table `jwt_tokens`
--

CREATE TABLE `jwt_tokens` (
  `id` int(11) NOT NULL,
  `token` text NOT NULL,
  `iat` int(11) NOT NULL,
  `exp` int(11) NOT NULL,
  `type` enum('access','refresh') NOT NULL,
  `used` tinyint(1) DEFAULT 0,
  `created_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `jwt_tokens`
--

INSERT INTO `jwt_tokens` (`id`, `token`, `iat`, `exp`, `type`, `used`, `created_at`) VALUES
(272, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwOi8vbGlicmFyeS5vcmciLCJhdWQiOiJodHRwOi8vbGlicmFyeS5jb20iLCJpYXQiOjE3Mjk0NzYwNjMsImV4cCI6MTcyOTQ3OTY2M30.qr4zAmhUxF4GfXII0oEPes8i6TBgCwfgZZkEQrrFlE4', 0, 0, 'access', 1, '2024-10-21 10:01:03'),
(273, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwOi8vbGlicmFyeS5vcmciLCJhdWQiOiJodHRwOi8vbGlicmFyeS5jb20iLCJpYXQiOjE3Mjk0NzYyMDIsImV4cCI6MTcyOTQ3OTgwMn0.P8hFgxaTktU964Ohj2edeARJwkhUbV0oTP3hu-AnE1Y', 0, 0, 'access', 0, '2024-10-21 10:03:22'),
(274, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwOi8vbGlicmFyeS5vcmciLCJhdWQiOiJodHRwOi8vbGlicmFyeS5jb20iLCJpYXQiOjE3Mjk0NzYyNTAsImV4cCI6MTcyOTQ3OTg1MH0.trCQJrzIK_r7POv_8O0wPyqZ0FXcO--qSPy2fDimQ3s', 0, 0, 'access', 1, '2024-10-21 10:04:10'),
(275, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwOi8vbGlicmFyeS5vcmciLCJhdWQiOiJodHRwOi8vbGlicmFyeS5jb20iLCJpYXQiOjE3Mjk0NzYyOTksImV4cCI6MTcyOTQ3OTg5OX0.vPla6WCTuZLA1ks72La-iE2fQnYjFRsCJUNHHy7l7wU', 0, 0, 'access', 1, '2024-10-21 10:04:59'),
(276, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwOi8vbGlicmFyeS5vcmciLCJhdWQiOiJodHRwOi8vbGlicmFyeS5jb20iLCJpYXQiOjE3Mjk0NzY3NzcsImV4cCI6MTcyOTQ4MDM3N30.R0fwTbJpHz7RHUdabSOCLmy6Qj2IId-3bsGlJe2qVHE', 0, 0, 'access', 1, '2024-10-21 10:12:57'),
(277, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwOi8vbGlicmFyeS5vcmciLCJhdWQiOiJodHRwOi8vbGlicmFyeS5jb20iLCJpYXQiOjE3Mjk0NzY4NTksImV4cCI6MTcyOTQ4MDQ1OX0.fAVs-NIoSoeSeHZYaIjgAr2-aUFBw90xy5fc6fe3Avk', 0, 0, 'access', 1, '2024-10-21 10:14:19'),
(278, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwOi8vbGlicmFyeS5vcmciLCJhdWQiOiJodHRwOi8vbGlicmFyeS5jb20iLCJpYXQiOjE3Mjk0NzcwNjQsImV4cCI6MTcyOTQ4MDY2NH0.dZ8RXzYf2U67ZjFPFrc09W21OC0aJtKFj7TkknvGUKU', 0, 0, 'access', 1, '2024-10-21 10:17:44'),
(279, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwOi8vbGlicmFyeS5vcmciLCJhdWQiOiJodHRwOi8vbGlicmFyeS5jb20iLCJpYXQiOjE3Mjk0NzcxNDksImV4cCI6MTcyOTQ4MDc0OX0.2jFlVO8RbZ0-oK-7oD6ptcIR1lkYIDMYEz1UN5I9V4s', 0, 0, 'access', 1, '2024-10-21 10:19:09'),
(280, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwOi8vbGlicmFyeS5vcmciLCJhdWQiOiJodHRwOi8vbGlicmFyeS5jb20iLCJpYXQiOjE3Mjk0NzcxNzIsImV4cCI6MTcyOTQ4MDc3Mn0.iELGJKitGTJZiUE6nTDZzXaMQ1zlfIGTkhN0BGyDNU8', 0, 0, 'access', 1, '2024-10-21 10:19:32'),
(281, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwOi8vbGlicmFyeS5vcmciLCJhdWQiOiJodHRwOi8vbGlicmFyeS5jb20iLCJpYXQiOjE3Mjk0NzcyMjksImV4cCI6MTcyOTQ4MDgyOX0.LHxaMByqzXgn7G_903hbL7f6DQ9mgYqeO9qeyTC8Yvc', 0, 0, 'access', 1, '2024-10-21 10:20:29'),
(282, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwOi8vbGlicmFyeS5vcmciLCJhdWQiOiJodHRwOi8vbGlicmFyeS5jb20iLCJpYXQiOjE3Mjk0NzcyNjAsImV4cCI6MTcyOTQ4MDg2MH0.M-Qg7QiSyQ9YHXWR-XWFCYmMKU13WWNclvwMS4X52PE', 0, 0, 'access', 1, '2024-10-21 10:21:00'),
(283, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwOi8vbGlicmFyeS5vcmciLCJhdWQiOiJodHRwOi8vbGlicmFyeS5jb20iLCJpYXQiOjE3Mjk0NzcyODMsImV4cCI6MTcyOTQ4MDg4M30.mVzKEXzO0jdyJwqJ1o0OxdPV4VSewArtQ7XFmbHDMa0', 0, 0, 'access', 1, '2024-10-21 10:21:23'),
(284, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwOi8vbGlicmFyeS5vcmciLCJhdWQiOiJodHRwOi8vbGlicmFyeS5jb20iLCJpYXQiOjE3Mjk0NzczMDQsImV4cCI6MTcyOTQ4MDkwNH0.ReB4tC9Lni-RN4S9m7U6pwfq3yP9XmKD64FXf9_b-ZY', 0, 0, 'access', 1, '2024-10-21 10:21:44'),
(285, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwOi8vbGlicmFyeS5vcmciLCJhdWQiOiJodHRwOi8vbGlicmFyeS5jb20iLCJpYXQiOjE3Mjk0Nzc0NTIsImV4cCI6MTcyOTQ4MTA1Mn0.U7I90DuaoZ2vASxmFyXcLhLdxm6Y7obBEe8H0A4RAVg', 0, 0, 'access', 1, '2024-10-21 10:24:12'),
(286, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwOi8vbGlicmFyeS5vcmciLCJhdWQiOiJodHRwOi8vbGlicmFyeS5jb20iLCJpYXQiOjE3Mjk0Nzc0NzQsImV4cCI6MTcyOTQ4MTA3NH0.xNwZTd6t9gVi3GZMpRmi20wwJ6ZYH0Qi1Q972bwmqrw', 0, 0, 'access', 1, '2024-10-21 10:24:34'),
(287, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwOi8vbGlicmFyeS5vcmciLCJhdWQiOiJodHRwOi8vbGlicmFyeS5jb20iLCJpYXQiOjE3Mjk0Nzc0OTUsImV4cCI6MTcyOTQ4MTA5NX0.rCpEM1vuvKEIsZiIdPbeX7piQQ4q8tXCCiSqa5KEQIY', 0, 0, 'access', 1, '2024-10-21 10:24:55'),
(288, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwOi8vbGlicmFyeS5vcmciLCJhdWQiOiJodHRwOi8vbGlicmFyeS5jb20iLCJpYXQiOjE3Mjk0Nzc1MjcsImV4cCI6MTcyOTQ4MTEyN30.yhQpAxWtITWGI-j0DaVbx1BN49U_96lovAmDj_WdR24', 0, 0, 'access', 1, '2024-10-21 10:25:27'),
(289, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwOi8vbGlicmFyeS5vcmciLCJhdWQiOiJodHRwOi8vbGlicmFyeS5jb20iLCJpYXQiOjE3Mjk0Nzc1NjksImV4cCI6MTcyOTQ4MTE2OX0.fjIRdTBd3iVncbP4JfAvCgTykqA80aXGRQBcjF1JFnQ', 0, 0, 'access', 0, '2024-10-21 10:26:09'),
(290, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwOi8vbGlicmFyeS5vcmciLCJhdWQiOiJodHRwOi8vbGlicmFyeS5jb20iLCJpYXQiOjE3Mjk0NzkyMzQsImV4cCI6MTcyOTQ4MjgzNH0.x3vww-cAj469MO7jLsQx6cFMhLv6eQMecupEgsNASWM', 1729479234, 1729482834, 'access', 0, '2024-10-21 10:53:54'),
(291, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwOi8vbGlicmFyeS5vcmciLCJhdWQiOiJodHRwOi8vbGlicmFyeS5jb20iLCJpYXQiOjE3Mjk0Nzk1MzQsImV4cCI6MTcyOTQ4MzEzNH0.rYXBGIF64av-igb2s_4AHyLhYEQc-kmzhAifz5ndNDE', 1729479534, 1729483134, 'access', 0, '2024-10-21 10:58:54');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `userid` int(9) NOT NULL,
  `username` char(255) NOT NULL,
  `password` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`userid`, `username`, `password`) VALUES
(118, 'majh', '$2y$10$YWZSOLPkvrRkL0O9uPz4zed0lxDiY8s6RN3aOaBmd/5Vqm0uZj0/C'),
(119, 'majhh', '$2y$10$80q9vfYxBwa3zRLOxo.25.5nW2zM45eUoAeDSdgqRi1aPVGI/ocH6'),
(120, 'name1', '$2y$10$azqpobYQb5g3ZyCHsKeVgeJLlVoBoOb6vNRpQWyv21OmdWOtYmZmS'),
(121, 'name2', '$2y$10$dnTsQGBlVvSBahDrrYEjuefYfGJVs/OauusMU9TEXExXu89ywJCoe'),
(122, 'name3', '$2y$10$6W1PqOmDki/c0mJE2yHkouWbPFhKLKxyftdJ4stbRJb1OO.rQYRTm'),
(123, 'name4', '$2y$10$TYkX/8//apkuGCozTl6vSe3p3FmMmfZ2J/yX6vUUf6gs0/Chf0GNC');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `authors`
--
ALTER TABLE `authors`
  ADD PRIMARY KEY (`authorid`);

--
-- Indexes for table `books`
--
ALTER TABLE `books`
  ADD PRIMARY KEY (`bookid`),
  ADD KEY `authorid` (`authorid`);

--
-- Indexes for table `books_authors`
--
ALTER TABLE `books_authors`
  ADD PRIMARY KEY (`collectionid`),
  ADD KEY `authorid` (`authorid`),
  ADD KEY `bookid` (`bookid`);

--
-- Indexes for table `jwt_tokens`
--
ALTER TABLE `jwt_tokens`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`userid`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `authors`
--
ALTER TABLE `authors`
  MODIFY `authorid` int(9) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=110;

--
-- AUTO_INCREMENT for table `books`
--
ALTER TABLE `books`
  MODIFY `bookid` int(9) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=157;

--
-- AUTO_INCREMENT for table `books_authors`
--
ALTER TABLE `books_authors`
  MODIFY `collectionid` int(9) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=108;

--
-- AUTO_INCREMENT for table `jwt_tokens`
--
ALTER TABLE `jwt_tokens`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=292;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `userid` int(9) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=124;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `books`
--
ALTER TABLE `books`
  ADD CONSTRAINT `books_ibfk_1` FOREIGN KEY (`authorid`) REFERENCES `authors` (`authorid`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `books_authors`
--
ALTER TABLE `books_authors`
  ADD CONSTRAINT `books_authors_ibfk_1` FOREIGN KEY (`authorid`) REFERENCES `authors` (`authorid`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `books_authors_ibfk_2` FOREIGN KEY (`bookid`) REFERENCES `books` (`bookid`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

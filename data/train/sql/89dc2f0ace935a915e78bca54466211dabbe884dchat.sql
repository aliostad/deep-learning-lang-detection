-- phpMyAdmin SQL Dump
-- version 4.4.11
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: 2016-02-02 00:35:21
-- 服务器版本： 5.6.14
-- PHP Version: 5.5.27

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `chat`
--

-- --------------------------------------------------------

--
-- 表的结构 `message`
--

CREATE TABLE IF NOT EXISTS `message` (
  `id` int(10) unsigned NOT NULL,
  `sender` varchar(64) NOT NULL,
  `receiver` varchar(64) NOT NULL,
  `content` text NOT NULL,
  `sendTime` datetime NOT NULL,
  `isGet` tinyint(4) NOT NULL DEFAULT '0'
) ENGINE=InnoDB AUTO_INCREMENT=67 DEFAULT CHARSET=utf8;

--
-- 转存表中的数据 `message`
--

INSERT INTO `message` (`id`, `sender`, `receiver`, `content`, `sendTime`, `isGet`) VALUES
(1, 'flash', 'Flash', 'www', '2016-01-30 20:36:51', 0),
(2, 'Zoom', 'Reverse Flash', 'kkk', '2016-01-30 20:39:49', 0),
(3, 'Zoom', 'Flash', 'ssss', '2016-01-30 21:47:43', 0),
(4, 'Zoom', 'Flash', 'rr', '2016-01-30 22:20:36', 0),
(5, 'Zoom', 'Flash', 'www', '2016-01-30 22:32:37', 0),
(6, 'Zoom', 'Reverse Flash', 'jjj', '2016-01-31 00:00:41', 0),
(7, 'Zoom', 'Flash', 'ttt', '2016-01-31 00:01:22', 0),
(8, 'Zoom', 'Zoom', 'ee', '2016-01-31 00:02:22', 0),
(9, 'Zoom', 'Flash', 'll', '2016-01-31 00:06:02', 0),
(10, 'Zoom', 'Reverse Flash', 'wewew', '2016-01-31 00:26:40', 0),
(11, 'Zoom', 'Flash', 'www', '2016-01-31 10:29:58', 0),
(12, 'Zoom', 'Flash', '444', '2016-01-31 10:31:01', 0),
(13, 'Zoom', 'Flash', 'eee', '2016-01-31 10:44:51', 0),
(14, 'Zoom', 'Flash', 'dd', '2016-01-31 10:46:09', 0),
(15, 'Zoom', 'Flash', 'dd', '2016-01-31 10:46:14', 0),
(16, 'Zoom', 'Flash', 'rrrr', '2016-01-31 10:58:10', 0),
(17, 'Zoom', 'Flash', 'ddd', '2016-01-31 11:00:52', 0),
(18, 'Flash', 'Zoom', 'ttttttttttttttttttttttttttt', '2016-01-31 11:04:27', 0),
(19, 'Zoom', 'Flash', 'Hello, cheers', '2016-01-31 11:06:08', 0),
(20, 'Zoom', 'Flash', 'Hello, cheers', '2016-01-31 11:08:27', 0),
(21, 'Flash', 'Flash', 'ddd', '2016-01-31 11:21:06', 0),
(22, 'Flash', 'Zoom', 'sss', '2016-01-31 11:22:00', 0),
(23, 'Flash', 'Zoom', 'sss', '2016-01-31 11:22:34', 0),
(24, 'Flash', 'Zoom', 'sss', '2016-01-31 11:22:37', 0),
(25, 'Zoom', 'Flash', 'xxxx', '2016-01-31 11:24:38', 0),
(26, 'Zoom', 'Flash', 'eeee', '2016-01-31 11:25:18', 0),
(27, 'Flash', 'Reverse Flash', 'fff', '2016-01-31 11:28:20', 0),
(28, 'Flash', 'Flash', 'ddd', '2016-01-31 11:30:48', 0),
(29, 'Flash', 'Flash', 'rrrr', '2016-01-31 11:32:36', 0),
(30, 'Flash', 'Flash', 'sss', '2016-01-31 11:33:09', 0),
(31, 'Flash', 'Flash', 'ddd', '2016-01-31 11:33:46', 0),
(32, 'Zoom', 'Flash', 'ss', '2016-01-31 11:35:22', 0),
(33, 'Zoom', 'Flash', 'kiki', '2016-01-31 11:37:40', 0),
(34, 'Zoom', 'Reverse Flash', 'sss', '2016-01-31 11:48:42', 0),
(35, 'Zoom', 'Reverse Flash', 'sss', '2016-01-31 11:49:56', 0),
(36, 'Zoom', 'Reverse Flash', 'sss', '2016-01-31 11:50:21', 0),
(37, 'Zoom', 'Reverse Flash', 'sss', '2016-01-31 11:50:21', 0),
(38, 'Zoom', 'Reverse Flash', 'sss', '2016-01-31 11:50:21', 0),
(39, 'Zoom', 'Reverse Flash', 'sss', '2016-01-31 11:50:21', 0),
(40, 'Zoom', 'Reverse Flash', 'sss', '2016-01-31 11:50:30', 0),
(41, 'Reverse Flah', 'Zoom', 'dddd', '2016-01-31 11:52:01', 0),
(42, 'Reverse Flah', 'Flash', 'wwwwwwwwwwwwww', '2016-01-31 12:04:17', 0),
(43, 'Reverse Flah', 'Flash', 'www', '2016-01-31 12:06:32', 0),
(44, 'Reverse Flah', 'Flash', 'www', '2016-01-31 12:07:42', 0),
(45, 'Reverse Flah', 'Flash', 'www', '2016-01-31 12:07:46', 0),
(46, 'Reverse Flah', 'Flash', 'aaa', '2016-01-31 12:08:09', 0),
(47, 'Reverse Flah', 'Flash', 'qqqq', '2016-01-31 12:08:55', 0),
(48, 'Reverse Flah', 'Flash', 'sss', '2016-01-31 12:09:15', 0),
(49, 'Reverse Flah', 'Flash', 'ooooo', '2016-01-31 12:10:40', 0),
(50, 'Reverse Flah', 'Flash', 'ooooo', '2016-01-31 12:11:53', 0),
(51, 'Reverse Flah', 'Flash', 'ooooo', '2016-01-31 12:11:54', 0),
(52, 'Reverse Flah', 'Flash', 'ooooo', '2016-01-31 12:11:54', 0),
(53, 'Reverse Flah', 'Flash', 'ooooo', '2016-01-31 12:11:54', 0),
(54, 'Reverse Flah', 'Flash', 'ooooo', '2016-01-31 12:11:54', 0),
(55, 'Reverse Flah', 'Flash', 'kioii', '2016-01-31 12:12:53', 0),
(56, 'Reverse Flah', 'Flash', 'kioii', '2016-01-31 12:13:55', 0),
(57, 'Reverse Flah', 'Flash', 'swswsw', '2016-01-31 12:15:07', 0),
(58, 'Reverse Flah', 'Flash', 'swswsw', '2016-01-31 12:16:34', 0),
(59, 'Reverse Flah', 'Flash', 'swswsw', '2016-01-31 12:17:22', 0),
(60, 'Zoom', 'Reverse Flash', 'ERERE', '2016-01-31 12:30:24', 0),
(61, 'Zoom', 'Reverse Flash', 'ERERE', '2016-01-31 12:31:35', 0),
(62, 'Zoom', 'Flash', 'eewwq', '2016-01-31 12:33:24', 0),
(63, 'Zoom', 'Flash', 'eewwq', '2016-01-31 12:34:26', 0),
(64, 'Zoom', 'Flash', 'hhh', '2016-01-31 12:35:53', 0),
(65, 'Zoom', 'Flash', 'ddddddddddddddddd', '2016-01-31 12:50:26', 0),
(66, 'Zoom', 'Flash', 'sss', '2016-01-31 13:16:09', 0);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `message`
--
ALTER TABLE `message`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `message`
--
ALTER TABLE `message`
  MODIFY `id` int(10) unsigned NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=67;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

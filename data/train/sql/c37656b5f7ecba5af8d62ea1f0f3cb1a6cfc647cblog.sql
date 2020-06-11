-- phpMyAdmin SQL Dump
-- version 4.3.12
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: 2015-04-26 01:52:48
-- 服务器版本： 5.6.12-log
-- PHP Version: 5.4.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `blog`
--

-- --------------------------------------------------------

--
-- 表的结构 `snail_about`
--

CREATE TABLE IF NOT EXISTS `snail_about` (
  `id` int(11) NOT NULL,
  `key` varchar(10) COLLATE utf8_bin NOT NULL,
  `value` text COLLATE utf8_bin NOT NULL,
  `display` tinyint(10) NOT NULL
) ENGINE=MyISAM AUTO_INCREMENT=9 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

--
-- 转存表中的数据 `snail_about`
--

INSERT INTO `snail_about` (`id`, `key`, `value`, `display`) VALUES
(1, 'B　u　g', '<p>页面仍然存在很多bug,和许多待优化的地方.如果您有更好的建议.请联系邮箱:1254075921@qq.com　　谢谢。</p>', 1),
(2, '姓　　名', '<p>██自己刮</p><p>一定要刮哦,不然看不到的说:)</p>', 1),
(3, '性　　别', '<p>男</p>', 1),
(4, '语　　言', '<p>国语，英语，日语，德语。（后三种不会）</p>', 1),
(5, '职　　业', '<p>整天游手好闲的人<br/>给我说清楚点.....<br/>一个不听话的学生</p>', 1),
(6, '爱　　好', '<p>爱好不多...<br/>其实自己也不知道是什么:)</p>', 1),
(7, '最　　爱', '<p>瞎搞:)~~~</p>', 1),
(8, '联系方式', '<p>不告诉你:)哼哼哼~~~</p>', 1);

-- --------------------------------------------------------

--
-- 表的结构 `snail_article`
--

CREATE TABLE IF NOT EXISTS `snail_article` (
  `id` int(11) NOT NULL,
  `type` varchar(15) COLLATE utf8_bin NOT NULL,
  `label` varchar(15) COLLATE utf8_bin NOT NULL,
  `title` varchar(30) COLLATE utf8_bin NOT NULL,
  `article` text COLLATE utf8_bin NOT NULL,
  `posttime` int(10) NOT NULL,
  `display` tinyint(10) NOT NULL
) ENGINE=MyISAM AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

--
-- 转存表中的数据 `snail_article`
--

INSERT INTO `snail_article` (`id`, `type`, `label`, `title`, `article`, `posttime`, `display`) VALUES
(1, 'blog', 'blog test', 'Hello world', '<p>This is my first article.I don&#39;t know what I should write.Since it is to write their own blog site first article. Then just Hello world!</p>', 1426983872, 1),
(2, 'left', 'left', '唯美生活', '<p>这是我的第一篇生活文章:)</p>', 1427087584, 0),
(3, 'blog', 'blog', '随记', '<p>网站后台功能整体完工~~　:)</p>', 1428768359, 1);

-- --------------------------------------------------------

--
-- 表的结构 `snail_flink`
--

CREATE TABLE IF NOT EXISTS `snail_flink` (
  `id` int(11) NOT NULL,
  `webname` varchar(30) COLLATE utf8_bin NOT NULL,
  `url` varchar(60) COLLATE utf8_bin NOT NULL,
  `display` tinyint(10) NOT NULL
) ENGINE=MyISAM AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

--
-- 转存表中的数据 `snail_flink`
--

INSERT INTO `snail_flink` (`id`, `webname`, `url`, `display`) VALUES
(1, 'StarPHP', 'http://www.starphp.net', 1),
(2, '蔚蓝的web', 'http://www.wl3w.com', 1),
(3, 'W3school学院', 'http://www.w3school.com.cn', 1);

-- --------------------------------------------------------

--
-- 表的结构 `snail_label`
--

CREATE TABLE IF NOT EXISTS `snail_label` (
  `id` int(11) NOT NULL,
  `labels` varchar(10) COLLATE utf8_bin NOT NULL,
  `label` varchar(30) COLLATE utf8_bin NOT NULL,
  `display` tinyint(10) NOT NULL
) ENGINE=MyISAM AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

--
-- 转存表中的数据 `snail_label`
--

INSERT INTO `snail_label` (`id`, `labels`, `label`, `display`) VALUES
(1, '测试', 'test', 1),
(2, 'Blog', 'blog', 1),
(3, 'Left', 'left', 0);

-- --------------------------------------------------------

--
-- 表的结构 `snail_nav`
--

CREATE TABLE IF NOT EXISTS `snail_nav` (
  `id` int(11) NOT NULL,
  `model` tinyint(10) NOT NULL,
  `zhli` varchar(15) COLLATE utf8_bin NOT NULL,
  `enli` varchar(15) COLLATE utf8_bin DEFAULT NULL,
  `path` varchar(30) COLLATE utf8_bin NOT NULL,
  `display` tinyint(10) NOT NULL
) ENGINE=MyISAM AUTO_INCREMENT=10 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

--
-- 转存表中的数据 `snail_nav`
--

INSERT INTO `snail_nav` (`id`, `model`, `zhli`, `enli`, `path`, `display`) VALUES
(1, 1, '首　　页', 'Protal', 'index', 1),
(2, 1, '关 于 我', 'About', 'Home/Index/about', 1),
(3, 1, '学无止境', 'Learn', 'Home/Index/learn', 1),
(4, 1, '慢 生 活', 'Left', 'Home/Index/left', 0),
(5, 0, '文　　章', NULL, 'Snail/Index/article', 1),
(6, 0, '导　　航', '', 'Snail/Nav', 1),
(7, 0, '标　　签', '', 'Snail/Label', 1),
(8, 0, '关　　于', '', 'Snail/About', 1),
(9, 0, '友　　链', '', 'Snail/Flink', 1);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `snail_about`
--
ALTER TABLE `snail_about`
  ADD PRIMARY KEY (`id`), ADD UNIQUE KEY `key` (`key`);

--
-- Indexes for table `snail_article`
--
ALTER TABLE `snail_article`
  ADD PRIMARY KEY (`id`), ADD KEY `type` (`type`), ADD KEY `label` (`label`), ADD KEY `title` (`title`), ADD KEY `index` (`posttime`);

--
-- Indexes for table `snail_flink`
--
ALTER TABLE `snail_flink`
  ADD PRIMARY KEY (`id`), ADD KEY `index` (`webname`), ADD KEY `url` (`url`);

--
-- Indexes for table `snail_label`
--
ALTER TABLE `snail_label`
  ADD PRIMARY KEY (`id`), ADD KEY `labels` (`labels`), ADD KEY `label` (`label`);

--
-- Indexes for table `snail_nav`
--
ALTER TABLE `snail_nav`
  ADD PRIMARY KEY (`id`), ADD KEY `zhli` (`zhli`), ADD KEY `enli` (`enli`), ADD KEY `path` (`path`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `snail_about`
--
ALTER TABLE `snail_about`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=9;
--
-- AUTO_INCREMENT for table `snail_article`
--
ALTER TABLE `snail_article`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=4;
--
-- AUTO_INCREMENT for table `snail_flink`
--
ALTER TABLE `snail_flink`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=4;
--
-- AUTO_INCREMENT for table `snail_label`
--
ALTER TABLE `snail_label`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=4;
--
-- AUTO_INCREMENT for table `snail_nav`
--
ALTER TABLE `snail_nav`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=10;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

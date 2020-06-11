-- phpMyAdmin SQL Dump
-- version 4.2.7.1
-- http://www.phpmyadmin.net
--
-- Host: 127.0.0.1
-- Generation Time: Jan 05, 2015 at 12:06 PM
-- Server version: 5.6.20
-- PHP Version: 5.5.15

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `library`
--

-- --------------------------------------------------------

--
-- Table structure for table `shelf`
--

CREATE TABLE IF NOT EXISTS `shelf` (
  `number` int(11) NOT NULL,
  `system` text COLLATE utf8_unicode_ci NOT NULL,
  `min` text COLLATE utf8_unicode_ci,
  `max` text COLLATE utf8_unicode_ci,
  `floor` int(11) NOT NULL,
  `zone` varchar(11) COLLATE utf8_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `shelf`
--

INSERT INTO `shelf` (`number`, `system`, `min`, `max`, `floor`, `zone`) VALUES
(1, 'old', 'A', 'BZ', 2, 'down'),
(2, 'old', 'C', 'DS578', 2, 'down'),
(3, 'old', 'DS578.1', 'GE195.I', 2, 'down'),
(4, 'old', 'GE195.J', 'HC59.7.V', 2, 'down'),
(5, 'old', 'HC59.7.W', 'HD58.82.G', 2, 'down'),
(6, 'old', 'HD58.82.H', 'HD9940.A2R', 2, 'down'),
(7, 'old', 'HD9940.A2S', 'HF5415.335.N7', 2, 'down'),
(8, 'old', 'HF5415.335.N8', 'HG179.E', 2, 'down'),
(9, 'old', 'HG179.F', 'HM526.H', 2, 'down'),
(10, 'old', 'HM526.I', 'HV1449', 2, 'down'),
(11, 'old', 'HV1450', 'JZ1300', 2, 'down'),
(12, 'old', 'JZ1301', 'KF4150', 2, 'down'),
(13, 'old', 'KF4151', 'MZ', 2, 'down'),
(14, 'old', 'N', 'NA2542', 2, 'down'),
(15, 'old', 'NA2543', 'NE', 2, 'down'),
(16, 'old', 'NK1', 'PE1111', 2, 'down'),
(17, 'old', 'PE1112', 'PN9999', 2, 'down'),
(18, 'old', 'PQ', 'QA76.9.C64', 2, 'left_r'),
(19, 'old', 'QA76.9.C65', 'QC99', 2, 'left_r'),
(21, 'old', 'QK1', 'T396.52', 2, 'left_r'),
(23, 'old', 'TH851', 'TK7875.Z', 2, 'left_r'),
(24, 'old', 'TK7876', 'TT850', 2, 'left_r'),
(25, 'old', 'TT851', 'ZZ', 2, 'left_r'),
(1, 'old', 'A', 'BF637.ส6ฝ', 3, 'right'),
(2, 'old', 'BF637.ส6พ', 'BQ942', 3, 'right'),
(3, 'old', 'BQ943', 'BQ5540', 3, 'right'),
(4, 'old', 'BQ5541', 'D11', 3, 'right'),
(5, 'old', 'D12', 'DS527.7.ท', 3, 'right'),
(6, 'old', 'DS527.7.ธ', 'DS570.3.ก1ฟ', 3, 'right'),
(7, 'old', 'DS570.3.ก1ภ', 'DS570.6.น3', 3, 'right'),
(8, 'old', 'DS570.6.น4', 'DS586.ก', 3, 'right'),
(9, 'old', 'DS586.ข', 'DS778.ม7น', 3, 'right'),
(10, 'old', 'DS778.ม7บ', 'GN635.ท9ม', 3, 'right'),
(11, 'old', 'GN635ท9ย', 'HB96', 3, 'right'),
(12, 'old', 'HB97', 'HD30.25.ก', 3, 'right'),
(13, 'old', 'HD30.25.ข', 'HD69.ค6ส42533', 3, 'right'),
(14, 'old', 'HD69.ค6ส42534', 'HD9066.ท92ก', 3, 'right'),
(15, 'old', 'HD9066.ท92ข', 'HF1382.7.ห3ส942545', 3, 'right'),
(16, 'old', 'HF1382.7.ห3ส942546', 'HF5548.4.ม9ส6', 3, 'right'),
(17, 'old', 'HF5548.4.ม9ส7', 'HG228.ฮ', 3, 'right'),
(18, 'old', 'HG229.ก', 'HM262.ฮ', 3, 'right'),
(19, 'old', 'HM263', 'HQ766.5.ฉ', 3, 'right'),
(20, 'old', 'HQ766.5.ช', 'HV8073.ห', 3, 'right'),
(21, 'old', 'HV8073.อ', 'JQ1745.ก52475ธ', 3, 'right'),
(22, 'old', 'JQ1745.ก52475น', 'K116', 3, 'right'),
(23, 'old', 'K117', 'KPT770.พ422550', 3, 'right'),
(24, 'old', 'KPT770.พ422551', 'KPT1690', 3, 'down'),
(25, 'old', 'KPT1691', 'KPT2809', 3, 'down'),
(26, 'old', 'KPT2810', 'KPT4610.ส4', 3, 'down'),
(27, 'old', 'KPT4610.ส5', 'LB2805.ส5', 3, 'down'),
(28, 'old', 'LB2805.ส6', 'N8193.1', 3, 'down'),
(29, 'old', 'N8193.2', 'P99.4.ษ', 3, 'down'),
(30, 'old', 'P99.4.ส', 'PL4151', 3, 'down'),
(31, 'old', 'PL4152', 'PL4203', 3, 'down'),
(32, 'old', 'PL4204', 'PL4209.7.ป432509', 3, 'down'),
(33, 'old', 'PL4209.7.ป432510', 'PN4781.ข', 3, 'down'),
(34, 'old', 'PN4781.ค', 'QA38', 3, 'down'),
(35, 'old', 'QA39', 'QA76.76.ป2อ6', 3, 'down'),
(36, 'old', 'QA76.76.ป2อ7', 'QA278.7', 3, 'down'),
(37, 'old', 'QA278.8', 'QD142.ธ', 3, 'down'),
(38, 'old', 'QD142.น', 'QL84.5.ท9บ', 3, 'down'),
(39, 'old', 'QL84.5.ท9ป', 'S471.ท9', 3, 'down'),
(40, 'old', 'S471.ท91', 'SD235.ท91ว', 3, 'down'),
(41, 'old', 'SD235.ท91ศ', 'TA350.น', 3, 'left'),
(42, 'old', 'TA350.บ', 'TJ213', 3, 'left'),
(43, 'old', 'TJ214', 'TK7866', 3, 'left'),
(44, 'old', 'TK7867', 'TS155.6.ม', 3, 'left'),
(45, 'old', 'TS155.6.ย', 'VM499', 3, 'left'),
(46, 'old', 'VM500', 'ZZ', 3, 'left'),
(28, 'new', 'CHEMQD2010630701', 'COMMDHF2014636032', 2, 'left_r'),
(29, 'new', 'COMMDP1997444770', 'CUSTGT2014632138', 2, 'left_r'),
(30, 'new', 'ECONHB2003507327', 'ENGINTS2014635351', 2, 'left_r'),
(32, 'new', 'GENAG2010619896', 'HECONTX2014635968', 2, 'left_r'),
(33, 'new', 'HISTD2006627235', 'HISTF2014636117', 2, 'left_r'),
(34, 'new', 'INDHD1996630231', 'INDHD2014635906', 2, 'left_r'),
(35, 'new', 'LANG&LITP1963631235', 'LANG&LITPZ2013628561', 2, 'left_r'),
(36, 'new', 'LAWK2003620180', 'LAWKPT2013634863', 2, 'left_r'),
(37, 'new', 'LAWKPT2014623596', 'LAWKZA2011592188', 2, 'left_r'),
(38, 'new', NULL, NULL, 2, 'left_r'),
(39, 'new', 'MANUFTS2003428507', 'MATHQA2014634711', 2, 'left_r'),
(40, 'new', 'MEDQP2005467549', 'MEDWZ2013621719', 2, 'left_r'),
(41, 'new', NULL, NULL, 2, 'left_r'),
(42, 'new', 'MGNTHD1977631983', 'MGNT2014635660', 2, 'left_r'),
(43, 'new', 'MILU1998630610', 'NUMISCJ2013623550', 2, 'left_l'),
(44, 'new', 'OCCBF1990630760', 'PHYSQC2014634767', 2, 'left_l'),
(45, 'new', 'PLSCJA1998274983', 'PSYCBF2014635461', 2, 'left_l'),
(46, 'new', 'PUBZ2007635686', 'RELBX2005633809', 2, 'left_l'),
(48, 'new', 'SOCYHM2000633950', 'SOCYHV2014634166', 2, 'left_l'),
(49, 'new', 'STATHA2012626882', 'STATHA2014634368', 2, 'left_l'),
(50, 'new', 'TECHT2009631145', 'TRANHE2014634621', 2, 'left_l'),
(51, 'new', 'ZOOLQL2009563692', 'ZOOLQL2014636227', 2, 'left_l');

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

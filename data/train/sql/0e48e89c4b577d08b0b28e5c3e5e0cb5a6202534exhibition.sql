-- --------------------------------------------------------
--
-- Table structure for table `exhibition`
--

CREATE TABLE IF NOT EXISTS `exhibition` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `Name` varchar(255) NOT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `Name` (`Name`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1;

--
-- Dumping data for table `exhibition`
--

INSERT INTO `exhibition` (`ID`, `Name`) VALUES
(2, 'Spring Show 2009'),
(4, 'Spring show 2010'),
(6, 'Spring Show 2011'),
(8, 'Spring Show 2012'),
(10, 'Spring Show 2013'),
(12, 'Spring Show 2014'),
(13, 'Spring Show 2015'),
(1, 'Summer Show 2008'),
(3, 'Summer Show 2009'),
(5, 'Summer Show 2010'),
(7, 'Summer Show 2011'),
(9, 'Summer Show 2012'),
(11, 'Summer Show 2013');



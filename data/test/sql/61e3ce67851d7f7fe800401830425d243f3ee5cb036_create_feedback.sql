CREATE TABLE `feedback` (
  `feedbackId` int(11) NOT NULL AUTO_INCREMENT,
  `userId` int(11) NOT NULL,
  `type` varchar(1) NOT NULL DEFAULT '',
  `suggestionText` text NOT NULL,
  `read` tinyint(1) NOT NULL DEFAULT '0',
  `submittedAt` bigint(20) NOT NULL,
  PRIMARY KEY (`feedbackId`),
  KEY `userId` (`userId`),
  KEY `read` (`read`),
  KEY `submittedAt` (`submittedAt`),
  CONSTRAINT `user_relationship` FOREIGN KEY (`userId`) REFERENCES `users` (`userId`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
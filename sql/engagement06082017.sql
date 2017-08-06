--
-- Table structure for table `engagement`
--

DROP TABLE IF EXISTS `engagement`;
CREATE TABLE `engagement` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user` varchar(60) NOT NULL,
  `follower` varchar(60) NOT NULL,
  `type` varchar(7) DEFAULT NULL,
  `time` DATETIME DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- phpMyAdmin SQL Dump
-- version 5.0.2
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1:3306
-- Generation Time: Apr 03, 2021 at 12:12 AM
-- Server version: 5.7.31
-- PHP Version: 7.3.21

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `fdm`
--

-- --------------------------------------------------------

--
-- Table structure for table `accounts`
--

DROP TABLE IF EXISTS `accounts`;
CREATE TABLE IF NOT EXISTS `accounts` (
  `acc_dbid` int(11) NOT NULL AUTO_INCREMENT,
  `acc_name` varchar(32) NOT NULL DEFAULT '0',
  `acc_pass` varchar(128) NOT NULL DEFAULT '0',
  `register_ip` varchar(60) NOT NULL DEFAULT '0',
  `register_date` varchar(90) NOT NULL DEFAULT '0',
  `acc_score` int(225) DEFAULT '0',
  `acc_deaths` int(225) DEFAULT '0',
  `acc_kills` int(225) DEFAULT '0',
  `acc_money` int(10) DEFAULT '0',
  `pAdmin` int(2) DEFAULT '0',
  `pMute` varchar(1) DEFAULT '0',
  `pMuteReason` varchar(64) NOT NULL DEFAULT '0',
  `pBan` int(11) DEFAULT '0',
  `pBanReason` varchar(150) NOT NULL DEFAULT '0',
  `pBanAdmin` varchar(32) NOT NULL DEFAULT '0',
  `pDonator` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`acc_dbid`)
) ENGINE=InnoDB AUTO_INCREMENT=55 DEFAULT CHARSET=latin1;

--
-- Dumping data for table `accounts`
--


/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

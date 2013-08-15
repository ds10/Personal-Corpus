-- phpMyAdmin SQL Dump
-- version 4.0.4.1
-- http://www.phpmyadmin.net
--
-- Host: localhost:3306
-- Generation Time: Aug 12, 2013 at 03:46 AM
-- Server version: 5.5.32
-- PHP Version: 5.4.17

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `personalcorpus`
--
CREATE DATABASE IF NOT EXISTS `personalcorpus` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;
USE `personalcorpus`;

-- --------------------------------------------------------

--
-- Table structure for table `store`
--

CREATE TABLE IF NOT EXISTS `store` (
  `id` int(255) NOT NULL AUTO_INCREMENT,
  `store` varchar(5000) NOT NULL,
  `site` varchar(512) NOT NULL,
  `date` date NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

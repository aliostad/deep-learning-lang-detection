-- phpMyAdmin SQL Dump
-- version 4.5.3.1
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Feb 14, 2016 at 10:24 PM
-- Server version: 5.6.28-0ubuntu0.15.10.1
-- PHP Version: 5.6.11-1ubuntu3.1

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";

--
-- Database: `felicity_contestdb`
--

-- --------------------------------------------------------

--
-- Table structure for table `ttt_payment_dump`
--

CREATE TABLE `ttt_payment_dump` (
  `id` int(11) NOT NULL,
  `nick` varchar(64) NOT NULL,
  `type` enum('callback','webhook') NOT NULL,
  `response` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `ttt_registrations`
--

CREATE TABLE `ttt_registrations` (
  `id` int(11) NOT NULL,
  `nick` varchar(64) NOT NULL,
  `contact_number` varchar(15) NOT NULL,
  `payment_status` enum('pending','failed','success') NOT NULL DEFAULT 'pending',
  `payment_id` varchar(100) DEFAULT NULL,
  `payment_data` text
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `ttt_payment_dump`
--
ALTER TABLE `ttt_payment_dump`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `ttt_registrations`
--
ALTER TABLE `ttt_registrations`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `ttt_payment_dump`
--
ALTER TABLE `ttt_payment_dump`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `ttt_registrations`
--
ALTER TABLE `ttt_registrations`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

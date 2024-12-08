-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Nov 05, 2024 at 06:20 PM
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
-- Database: `datab5`
--

-- --------------------------------------------------------

--
-- Table structure for table `clients`
--

CREATE TABLE `clients` (
  `client_id` int(11) NOT NULL,
  `first_name` varchar(50) DEFAULT NULL,
  `last_name` varchar(50) DEFAULT NULL,
  `city` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `clients`
--

INSERT INTO `clients` (`client_id`, `first_name`, `last_name`, `city`) VALUES
(201, 'Client1', 'LastName1', 'Klaipeda'),
(202, 'Client2', 'LastName2', 'Kaunas'),
(203, 'Client3', 'LastName3', 'Siauliai'),
(204, 'Client4', 'LastName4', 'Klaipeda'),
(205, 'Client5', 'LastName5', 'Vilnius'),
(206, 'Client6', 'LastName6', 'Klaipeda'),
(207, 'Client7', 'LastName7', 'Vilnius'),
(208, 'Client8', 'LastName8', 'Siauliai'),
(209, 'Client9', 'LastName9', 'Klaipeda'),
(210, 'Client10', 'LastName10', 'Siauliai'),
(211, 'Client11', 'LastName11', 'Kaunas'),
(212, 'Client12', 'LastName12', 'Vilnius'),
(213, 'Client13', 'LastName13', 'Klaipeda'),
(214, 'Client14', 'LastName14', 'Vilnius'),
(215, 'Client15', 'LastName15', 'Vilnius'),
(216, 'Client16', 'LastName16', 'Klaipeda'),
(217, 'Client17', 'LastName17', 'Klaipeda'),
(218, 'Client18', 'LastName18', 'Vilnius'),
(219, 'Client19', 'LastName19', 'Siauliai'),
(220, 'Client20', 'LastName20', 'Kaunas'),
(221, 'Client21', 'LastName21', 'Siauliai'),
(222, 'Client22', 'LastName22', 'Kaunas'),
(223, 'Client23', 'LastName23', 'Siauliai'),
(224, 'Client24', 'LastName24', 'Vilnius'),
(225, 'Client25', 'LastName25', 'Klaipeda'),
(226, 'Client26', 'LastName26', 'Klaipeda'),
(227, 'Client27', 'LastName27', 'Vilnius'),
(228, 'Client28', 'LastName28', 'Klaipeda'),
(229, 'Client29', 'LastName29', 'Vilnius'),
(230, 'Client30', 'LastName30', 'Vilnius'),
(231, 'Client31', 'LastName31', 'Vilnius'),
(232, 'Client32', 'LastName32', 'Klaipeda'),
(233, 'Client33', 'LastName33', 'Klaipeda'),
(234, 'Client34', 'LastName34', 'Klaipeda'),
(235, 'Client35', 'LastName35', 'Klaipeda'),
(236, 'Client36', 'LastName36', 'Kaunas'),
(237, 'Client37', 'LastName37', 'Vilnius'),
(238, 'Client38', 'LastName38', 'Kaunas'),
(239, 'Client39', 'LastName39', 'Kaunas'),
(240, 'Client40', 'LastName40', 'Klaipeda'),
(241, 'Client41', 'LastName41', 'Klaipeda'),
(242, 'Client42', 'LastName42', 'Vilnius'),
(243, 'Client43', 'LastName43', 'Kaunas'),
(244, 'Client44', 'LastName44', 'Vilnius'),
(245, 'Client45', 'LastName45', 'Klaipeda'),
(246, 'Client46', 'LastName46', 'Kaunas'),
(247, 'Client47', 'LastName47', 'Klaipeda'),
(248, 'Client48', 'LastName48', 'Kaunas'),
(249, 'Client49', 'LastName49', 'Vilnius'),
(250, 'Client50', 'LastName50', 'Klaipeda');

-- --------------------------------------------------------

--
-- Table structure for table `employees`
--

CREATE TABLE `employees` (
  `employee_id` int(11) NOT NULL,
  `first_name` varchar(50) DEFAULT NULL,
  `last_name` varchar(50) DEFAULT NULL,
  `city` varchar(50) DEFAULT NULL,
  `department` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `employees`
--

INSERT INTO `employees` (`employee_id`, `first_name`, `last_name`, `city`, `department`) VALUES
(101, 'FirstName1', 'LastName1', 'Vilnius', 'HR'),
(102, 'FirstName2', 'LastName2', 'Klaipeda', 'IT'),
(103, 'FirstName3', 'LastName3', 'Vilnius', 'HR'),
(104, 'FirstName4', 'LastName4', 'Vilnius', 'Finance'),
(105, 'FirstName5', 'LastName5', 'Klaipeda', 'HR'),
(106, 'FirstName6', 'LastName6', 'Vilnius', 'IT'),
(107, 'FirstName7', 'LastName7', 'Klaipeda', 'HR'),
(108, 'FirstName8', 'LastName8', 'Siauliai', 'Finance'),
(109, 'FirstName9', 'LastName9', 'Kaunas', 'Finance'),
(110, 'FirstName10', 'LastName10', 'Siauliai', 'HR'),
(111, 'FirstName11', 'LastName11', 'Klaipeda', 'Finance'),
(112, 'FirstName12', 'LastName12', 'Vilnius', 'HR'),
(113, 'FirstName13', 'LastName13', 'Kaunas', 'IT'),
(114, 'FirstName14', 'LastName14', 'Klaipeda', 'HR'),
(115, 'FirstName15', 'LastName15', 'Vilnius', 'HR'),
(116, 'FirstName16', 'LastName16', 'Klaipeda', 'HR'),
(117, 'FirstName17', 'LastName17', 'Kaunas', 'HR'),
(118, 'FirstName18', 'LastName18', 'Kaunas', 'HR'),
(119, 'FirstName19', 'LastName19', 'Klaipeda', 'Finance'),
(120, 'FirstName20', 'LastName20', 'Klaipeda', 'HR'),
(121, 'FirstName21', 'LastName21', 'Siauliai', 'Finance'),
(122, 'FirstName22', 'LastName22', 'Klaipeda', 'IT'),
(123, 'FirstName23', 'LastName23', 'Klaipeda', 'HR'),
(124, 'FirstName24', 'LastName24', 'Siauliai', 'HR'),
(125, 'FirstName25', 'LastName25', 'Siauliai', 'HR'),
(126, 'FirstName26', 'LastName26', 'Siauliai', 'Finance'),
(127, 'FirstName27', 'LastName27', 'Vilnius', 'Finance'),
(128, 'FirstName28', 'LastName28', 'Vilnius', 'HR'),
(129, 'FirstName29', 'LastName29', 'Kaunas', 'IT'),
(130, 'FirstName30', 'LastName30', 'Kaunas', 'HR'),
(131, 'FirstName31', 'LastName31', 'Siauliai', 'IT'),
(132, 'FirstName32', 'LastName32', 'Kaunas', 'Finance'),
(133, 'FirstName33', 'LastName33', 'Vilnius', 'HR'),
(134, 'FirstName34', 'LastName34', 'Siauliai', 'Finance'),
(135, 'FirstName35', 'LastName35', 'Kaunas', 'Finance'),
(136, 'FirstName36', 'LastName36', 'Siauliai', 'Finance'),
(137, 'FirstName37', 'LastName37', 'Klaipeda', 'HR'),
(138, 'FirstName38', 'LastName38', 'Klaipeda', 'IT'),
(139, 'FirstName39', 'LastName39', 'Siauliai', 'Finance'),
(140, 'FirstName40', 'LastName40', 'Siauliai', 'IT'),
(141, 'FirstName41', 'LastName41', 'Kaunas', 'IT'),
(142, 'FirstName42', 'LastName42', 'Kaunas', 'HR'),
(143, 'FirstName43', 'LastName43', 'Siauliai', 'HR'),
(144, 'FirstName44', 'LastName44', 'Kaunas', 'Finance'),
(145, 'FirstName45', 'LastName45', 'Vilnius', 'IT'),
(146, 'FirstName46', 'LastName46', 'Kaunas', 'HR'),
(147, 'FirstName47', 'LastName47', 'Kaunas', 'IT'),
(148, 'FirstName48', 'LastName48', 'Vilnius', 'Finance'),
(149, 'FirstName49', 'LastName49', 'Vilnius', 'HR'),
(150, 'FirstName50', 'LastName50', 'Kaunas', 'IT');

-- --------------------------------------------------------

--
-- Table structure for table `employee_orders`
--

CREATE TABLE `employee_orders` (
  `order_id` int(11) NOT NULL,
  `employee_id` int(11) DEFAULT NULL,
  `product_id` int(11) DEFAULT NULL,
  `order_date` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `orders`
--

CREATE TABLE `orders` (
  `order_id` int(11) NOT NULL,
  `client_id` int(11) DEFAULT NULL,
  `product_id` int(11) DEFAULT NULL,
  `order_date` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `orders`
--

INSERT INTO `orders` (`order_id`, `client_id`, `product_id`, `order_date`) VALUES
(1, 235, 35, '2024-03-20'),
(2, 205, 9, '2024-04-04'),
(3, 207, 5, '2024-01-05'),
(4, 244, 13, '2024-04-30'),
(5, 229, 44, '2024-04-17'),
(6, 220, 9, '2024-05-02'),
(7, 244, 16, '2024-06-20'),
(8, 241, 12, '2024-05-06'),
(9, 241, 49, '2024-03-09'),
(10, 250, 42, '2024-02-06'),
(11, 225, 44, '2024-06-07'),
(12, 239, 10, '2024-04-27'),
(13, 234, 23, '2024-02-03'),
(14, 230, 20, '2024-02-05'),
(15, 240, 18, '2024-03-10'),
(16, 244, 11, '2024-03-23'),
(17, 232, 39, '2024-06-29'),
(18, 234, 17, '2024-04-30'),
(19, 218, 36, '2024-03-27'),
(20, 215, 3, '2024-02-29'),
(21, 225, 26, '2024-01-11'),
(22, 238, 30, '2024-05-10'),
(23, 241, 47, '2024-02-08'),
(24, 213, 32, '2024-03-12'),
(25, 205, 13, '2024-01-01'),
(26, 213, 12, '2024-03-10'),
(27, 213, 7, '2024-05-31'),
(28, 243, 35, '2024-06-12'),
(29, 223, 30, '2024-04-11'),
(30, 202, 26, '2024-03-15'),
(31, 227, 22, '2024-04-11'),
(32, 226, 46, '2024-06-21'),
(33, 204, 24, '2024-01-27'),
(34, 216, 6, '2024-04-19'),
(35, 237, 40, '2024-05-26'),
(36, 234, 48, '2024-05-03'),
(37, 230, 44, '2024-04-13'),
(38, 214, 30, '2024-02-07'),
(39, 212, 28, '2024-01-17'),
(40, 239, 27, '2024-03-16'),
(41, 224, 5, '2024-01-11'),
(42, 250, 41, '2024-01-20'),
(43, 204, 1, '2024-05-30'),
(44, 208, 15, '2024-06-27'),
(45, 203, 16, '2024-03-12'),
(46, 203, 2, '2024-06-29'),
(47, 247, 31, '2024-02-17'),
(48, 225, 32, '2024-05-10'),
(49, 236, 18, '2024-04-21'),
(50, 203, 19, '2024-05-11');

-- --------------------------------------------------------

--
-- Table structure for table `products`
--

CREATE TABLE `products` (
  `product_id` int(11) NOT NULL,
  `product_name` varchar(50) DEFAULT NULL,
  `price` decimal(10,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `products`
--

INSERT INTO `products` (`product_id`, `product_name`, `price`) VALUES
(1, 'Product1', 298.00),
(2, 'Product2', 1938.00),
(3, 'Product3', 1095.00),
(4, 'Product4', 1463.00),
(5, 'Product5', 131.00),
(6, 'Product6', 1865.00),
(7, 'Product7', 1231.00),
(8, 'Product8', 460.00),
(9, 'Product9', 407.00),
(10, 'Product10', 554.00),
(11, 'Product11', 1448.00),
(12, 'Product12', 1680.00),
(13, 'Product13', 154.00),
(14, 'Product14', 1332.00),
(15, 'Product15', 396.00),
(16, 'Product16', 1687.00),
(17, 'Product17', 1445.00),
(18, 'Product18', 164.00),
(19, 'Product19', 185.00),
(20, 'Product20', 335.00),
(21, 'Product21', 1017.00),
(22, 'Product22', 182.00),
(23, 'Product23', 1559.00),
(24, 'Product24', 1450.00),
(25, 'Product25', 571.00),
(26, 'Product26', 305.00),
(27, 'Product27', 1611.00),
(28, 'Product28', 1342.00),
(29, 'Product29', 1778.00),
(30, 'Product30', 963.00),
(31, 'Product31', 1280.00),
(32, 'Product32', 1510.00),
(33, 'Product33', 1711.00),
(34, 'Product34', 126.00),
(35, 'Product35', 1098.00),
(36, 'Product36', 1210.00),
(37, 'Product37', 758.00),
(38, 'Product38', 1960.00),
(39, 'Product39', 1727.00),
(40, 'Product40', 755.00),
(41, 'Product41', 391.00),
(42, 'Product42', 1493.00),
(43, 'Product43', 492.00),
(44, 'Product44', 1679.00),
(45, 'Product45', 1119.00),
(46, 'Product46', 458.00),
(47, 'Product47', 734.00),
(48, 'Product48', 294.00),
(49, 'Product49', 1069.00),
(50, 'Product50', 562.00);

-- --------------------------------------------------------

--
-- Table structure for table `students`
--

CREATE TABLE `students` (
  `student_id` int(11) NOT NULL,
  `first_name` varchar(50) DEFAULT NULL,
  `last_name` varchar(50) DEFAULT NULL,
  `city` varchar(50) DEFAULT NULL,
  `course` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `students`
--

INSERT INTO `students` (`student_id`, `first_name`, `last_name`, `city`, `course`) VALUES
(1, 'FirstName1', 'LastName1', 'Panevezys', 'IT'),
(2, 'FirstName2', 'LastName2', 'Klaipeda', 'IT'),
(3, 'FirstName3', 'LastName3', 'Vilnius', 'IT'),
(4, 'FirstName4', 'LastName4', 'Klaipeda', 'Business'),
(5, 'FirstName5', 'LastName5', 'Klaipeda', 'IT'),
(6, 'FirstName6', 'LastName6', 'Kaunas', 'IT'),
(7, 'FirstName7', 'LastName7', 'Kaunas', 'IT'),
(8, 'FirstName8', 'LastName8', 'Kaunas', 'Business'),
(9, 'FirstName9', 'LastName9', 'Vilnius', 'Business'),
(10, 'FirstName10', 'LastName10', 'Klaipeda', 'Business'),
(11, 'FirstName11', 'LastName11', 'Panevezys', 'Business'),
(12, 'FirstName12', 'LastName12', 'Kaunas', 'IT'),
(13, 'FirstName13', 'LastName13', 'Kaunas', 'Business'),
(14, 'FirstName14', 'LastName14', 'Kaunas', 'IT'),
(15, 'FirstName15', 'LastName15', 'Kaunas', 'IT'),
(16, 'FirstName16', 'LastName16', 'Vilnius', 'Mechanics'),
(17, 'FirstName17', 'LastName17', 'Kaunas', 'IT'),
(18, 'FirstName18', 'LastName18', 'Klaipeda', 'IT'),
(19, 'FirstName19', 'LastName19', 'Panevezys', 'Mechanics'),
(20, 'FirstName20', 'LastName20', 'Vilnius', 'IT'),
(21, 'FirstName21', 'LastName21', 'Vilnius', 'Business'),
(22, 'FirstName22', 'LastName22', 'Vilnius', 'Mechanics'),
(23, 'FirstName23', 'LastName23', 'Klaipeda', 'Business'),
(24, 'FirstName24', 'LastName24', 'Vilnius', 'IT'),
(25, 'FirstName25', 'LastName25', 'Vilnius', 'Mechanics'),
(26, 'FirstName26', 'LastName26', 'Vilnius', 'IT'),
(27, 'FirstName27', 'LastName27', 'Kaunas', 'Mechanics'),
(28, 'FirstName28', 'LastName28', 'Klaipeda', 'Business'),
(29, 'FirstName29', 'LastName29', 'Klaipeda', 'Mechanics'),
(30, 'FirstName30', 'LastName30', 'Vilnius', 'IT'),
(31, 'FirstName31', 'LastName31', 'Klaipeda', 'Business'),
(32, 'FirstName32', 'LastName32', 'Klaipeda', 'Business'),
(33, 'FirstName33', 'LastName33', 'Vilnius', 'Business'),
(34, 'FirstName34', 'LastName34', 'Klaipeda', 'IT'),
(35, 'FirstName35', 'LastName35', 'Vilnius', 'Business'),
(36, 'FirstName36', 'LastName36', 'Kaunas', 'IT'),
(37, 'FirstName37', 'LastName37', 'Kaunas', 'Mechanics'),
(38, 'FirstName38', 'LastName38', 'Klaipeda', 'Business'),
(39, 'FirstName39', 'LastName39', 'Klaipeda', 'IT'),
(40, 'FirstName40', 'LastName40', 'Vilnius', 'Mechanics'),
(41, 'FirstName41', 'LastName41', 'Vilnius', 'Business'),
(42, 'FirstName42', 'LastName42', 'Kaunas', 'Business'),
(43, 'FirstName43', 'LastName43', 'Panevezys', 'IT'),
(44, 'FirstName44', 'LastName44', 'Kaunas', 'Business'),
(45, 'FirstName45', 'LastName45', 'Panevezys', 'Business'),
(46, 'FirstName46', 'LastName46', 'Kaunas', 'Mechanics'),
(47, 'FirstName47', 'LastName47', 'Panevezys', 'IT'),
(48, 'FirstName48', 'LastName48', 'Klaipeda', 'IT'),
(49, 'FirstName49', 'LastName49', 'Panevezys', 'Business'),
(50, 'FirstName50', 'LastName50', 'Panevezys', 'Business');

-- --------------------------------------------------------

--
-- Table structure for table `time_machine`
--

CREATE TABLE `time_machine` (
  `record_id` int(11) NOT NULL,
  `effective_date` date NOT NULL,
  `expiration_date` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `clients`
--
ALTER TABLE `clients`
  ADD PRIMARY KEY (`client_id`);

--
-- Indexes for table `employees`
--
ALTER TABLE `employees`
  ADD PRIMARY KEY (`employee_id`);

--
-- Indexes for table `employee_orders`
--
ALTER TABLE `employee_orders`
  ADD PRIMARY KEY (`order_id`),
  ADD KEY `employee_id` (`employee_id`),
  ADD KEY `product_id` (`product_id`);

--
-- Indexes for table `orders`
--
ALTER TABLE `orders`
  ADD PRIMARY KEY (`order_id`);

--
-- Indexes for table `products`
--
ALTER TABLE `products`
  ADD PRIMARY KEY (`product_id`);

--
-- Indexes for table `students`
--
ALTER TABLE `students`
  ADD PRIMARY KEY (`student_id`);

--
-- Indexes for table `time_machine`
--
ALTER TABLE `time_machine`
  ADD PRIMARY KEY (`record_id`);

--
-- Constraints for dumped tables
--

--
-- Constraints for table `employee_orders`
--
ALTER TABLE `employee_orders`
  ADD CONSTRAINT `employee_orders_ibfk_1` FOREIGN KEY (`employee_id`) REFERENCES `employees` (`employee_id`),
  ADD CONSTRAINT `employee_orders_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `products` (`product_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

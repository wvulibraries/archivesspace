CREATE USER 'archivesspace'@'localhost' IDENTIFIED BY 'password';

DROP DATABASE IF EXISTS `archivesspace`;
CREATE DATABASE IF NOT EXISTS `archivesspace`;
GRANT ALL PRIVILEGES ON `archivesspace`.* TO 'archivesspace'@'localhost';
USE `archivesspace`;
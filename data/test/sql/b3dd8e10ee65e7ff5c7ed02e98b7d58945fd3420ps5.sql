/*
 * CS 133: HW5
 * 
 * Authors: Bruce Yan, Angela Zhou
 * E-mail: byan@hmc.edu, azhou@hmc.edu
 * 
 * Run this first! It will auto-populate the database with preset data
 *
*/

/* Populating PC table */

# Create an empty database 
DROP DATABASE IF EXISTS byazps5;

CREATE DATABASE byazps5;

# Grant privileges to user 'grader' with password 'allowme'
GRANT ALL PRIVILEGES ON byazps5.* to grader@localhost IDENTIFIED BY 'allowme';

# Explicitly use byazps5 that we just created 
USE byazps5;


# Products: relation that gives the mfg, model number, type of products
CREATE TABLE Products (
	model INTEGER NOT NULL,
	maker VARCHAR(256),
	type VARCHAR(64) NOT NULL,
	PRIMARY KEY (model)
);

# PCs: relation gives for each model number that is a PC the speed, amount of 
# ram, amount of HD, and price
CREATE TABLE PCs (
	model INTEGER NOT NULL,
	speed REAL,
	ram REAL,
	hd INTEGER,
	price REAL,
	PRIMARY KEY (model),
	FOREIGN KEY (model) REFERENCES Products (model)
);

# Laptops: relation gives for each model number that is a laptop the speed, 
# amount of ram, amount of HD, price and screen size
CREATE TABLE Laptops (
	model INTEGER NOT NULL,
	speed REAL,
	ram REAL,
	hd INTEGER,
	screen REAL,
	price REAL,
	PRIMARY KEY (model),
	FOREIGN KEY (model) REFERENCES Products (model)
);

# Printers: elation records for each printer model whether the printer produces
# color output (true, if so), the process type (laser or ink-jet, typically),
# and the price.
CREATE TABLE Printers (
	model INTEGER NOT NULL,
	color BOOLEAN NOT NULL,
	printertype VARCHAR(16),
	price REAL,
	PRIMARY KEY (model),
	FOREIGN KEY (model) REFERENCES Products (model)
);

# Load some sample Products
INSERT INTO Products (maker, model, type)
	VALUES ("HP", 1001, "PC");
INSERT INTO Products (maker, model, type)
	VALUES ("Lenovo", 1002, "PC");
INSERT INTO Products (maker, model, type)
	VALUES ("Sony", 1003, "PC");
INSERT INTO Products (maker, model, type)
	VALUES ("HP", 1004, "Laptop");
INSERT INTO Products (maker, model, type)
	VALUES ("IBM", 1005, "Laptop");
INSERT INTO Products (maker, model, type)
	VALUES ("Lenovo", 1006, "Laptop");
INSERT INTO Products (maker, model, type)
	VALUES ("Sony", 1007, "Laptop");
INSERT INTO Products (maker, model, type)
	VALUES ("Dell", 1008, "Laptop");
INSERT INTO Products (maker, model, type)
	VALUES ("Brother", 1009, "Printer");
INSERT INTO Products (maker, model, type)
	VALUES ("Konica Minolta", 1010, "Printer");
INSERT INTO Products (maker, model, type)
	VALUES ("HP", 1011, "Printer");


# Load some sample PCs
INSERT INTO PCs (model, speed, ram, hd, price) 
	VALUES (1001, 3.0, 8.0, 320, 1500);
INSERT INTO PCs (model, speed, ram, hd, price) 
	VALUES (1002, 2.8, 8.0, 500, 1690);
INSERT INTO PCs (model, speed, ram, hd, price) 
	VALUES (1003, 2.4, 16.0, 500, 1999);

# Load some sample Laptops	
INSERT INTO Laptops (model, speed, ram, hd, screen, price) 
	VALUES (1004, 1.8, 4.0, 120, 13, 1100);
INSERT INTO Laptops (model, speed, ram, hd, screen, price) 
	VALUES (1005, 1.7, 4.0, 120, 11, 1000);
INSERT INTO Laptops (model, speed, ram, hd, screen, price) 
	VALUES (1006, 2.0, 8.0, 250, 15, 1900);
INSERT INTO Laptops (model, speed, ram, hd, screen, price) 
	VALUES (1007, 2.4, 8.0, 250, 15, 2400);
INSERT INTO Laptops (model, speed, ram, hd, screen, price) 
	VALUES (1008, 2.8, 16.0, 500, 17, 3200);

# Load some sample Printers
INSERT INTO Printers (model, color, printertype, price) 
	VALUES (1009, FALSE, "Laser", 99);
INSERT INTO Printers (model, color, printertype, price) 
	VALUES (1010, FALSE, "Laser", 125);
INSERT INTO Printers (model, color, printertype, price) 
	VALUES (1011, TRUE, "Ink-Jet", 450);

# Sample Queries
SELECT * FROM Products;
SELECT * FROM PCs;
SELECT * FROM Laptops;
SELECT * FROM Printers;


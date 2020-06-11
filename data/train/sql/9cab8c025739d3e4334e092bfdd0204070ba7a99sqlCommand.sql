CREATE DATABASE carPrice;

USE carPrice;

CREATE TABLE cars(
	pos INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
	Model VARCHAR(25),
	Price INT,
	Image VARCHAR(256)
);

INSERT INTO cars SET
    Model = 'Opel Corsa',
	price = 70000;

INSERT INTO cars SET
    Model = 'Mitzubishi Lancer',
	price = 100000;

INSERT INTO cars SET
    Model = 'Mazda 3',
	price = 120000;

INSERT INTO cars SET
    Model = 'Honda Cisik',
	price = 70000;

INSERT INTO cars SET
    Model = 'Volvo',
	price = 180000;

INSERT INTO cars SET
    Model = 'Toyota Corola',
	price = 125000;
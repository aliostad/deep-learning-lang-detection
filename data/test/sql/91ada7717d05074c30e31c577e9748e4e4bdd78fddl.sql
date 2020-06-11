DROP TABLE IF EXISTS car;

CREATE TABLE car (
	id BIGINT PRIMARY KEY AUTO_INCREMENT,
    number_of_wheels INT DEFAULT 4,
    brand VARCHAR(20) NOT NULL,
    model VARCHAR(35) NOT NULL,
    number_plate VARCHAR(20) UNIQUE NOT NULL,
    color VARCHAR(25) NOT NULL,
    manufacturing_date DATE NOT NULL
);

INSERT INTO car (number_of_wheels, brand, model, number_plate, color, manufacturing_date) VALUES
	(4, "BMW", "318d", "ABC-123", "black", "2006-10-24"),
	(4, "BMW", "318d", "ABC-124", "black", "2007-10-24"),
	(4, "BMW", "320d", "ABC-125", "white", "2012-10-24");
    

DROP TABLE IF EXISTS car_model;

CREATE TABLE car_model (
	car_model_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    number_of_wheels INT DEFAULT 4,
    brand VARCHAR(20) NOT NULL,
    model VARCHAR(35) NOT NULL	
);

INSERT INTO car_model (brand, model, number_of_wheels) SELECT DISTINCT brand, model, number_of_wheels FROM car;

ALTER TABLE car ADD COLUMN car_model_id BIGINT;

UPDATE car c SET c.car_model_id =
	(SELECT m.car_model_id FROM car_model m
		WHERE m.brand = c.brand AND m.model = c.model AND m.number_of_wheels = c.number_of_wheels);

ALTER TABLE car CHANGE car_model_id car_model_id BIGINT NOT NULL,
	ADD FOREIGN KEY (car_model_id) REFERENCES car_model (car_model_id);
    
ALTER TABLE car
	DROP COLUMN model,
    DROP COLUMN brand,
    DROP COLUMN number_of_wheels;


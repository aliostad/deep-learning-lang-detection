-- Trigger that validates the new data on the car_location
---  knowing the IMEI update the car_id and
---  update the time to add the timezone
--
DROP TRIGGER IF EXISTS before_ins_car_location;
delimiter //
CREATE TRIGGER before_ins_car_location BEFORE INSERT ON car_location
FOR EACH ROW
 BEGIN
    IF NEW.car_lat = 0 THEN
        SET NEW.car_id = NULL;
    ELSE
        IF ((NEW.car_id = 100) OR (NEW.car_id = NULL)) AND (NEW.IMEI_number <> '') THEN
            SET @car_id = (SELECT car_id FROM car WHERE IMEI_number = NEW.IMEI_number);
            IF @car_id > 0 THEN
                SET NEW.car_id = @car_id;
                SET @car_gmt = (SELECT car_gmt FROM car WHERE IMEI_number = NEW.IMEI_number);
                SET NEW.geo_time = DATE_ADD(NEW.geo_time, INTERVAL @car_gmt HOUR);
                SET NEW.car_distance = NULL;
            END IF;
        END IF;
    END IF;
 END;//
delimiter ;

-- Trigger that adds the new records to a separate table
DROP TRIGGER IF EXISTS after_ins_car_location;
delimiter //
CREATE TRIGGER after_ins_car_location AFTER INSERT ON car_location
FOR EACH ROW
 BEGIN
    IF NEW.car_distance = NULL THEN
        INSERT INTO car_location_new (car_location_id)
        VALUES (NEW.car_location_id);
    END IF;
 END;//
delimiter ;


-- Trigger that moves the deleted record to another table
DROP TRIGGER IF EXISTS del_car_location;
delimiter //
CREATE TRIGGER del_car_location BEFORE DELETE ON car_location
FOR EACH ROW BEGIN
  INSERT INTO car_location_old (car_location_id)
  VALUES (OLD.car_location_id);
END
//
delimiter ;

use loggerdb;

CREATE TABLE sensor_info (
    sensor_id           VARCHAR(20) NOT NULL,
    sensor_name         VARCHAR(50) NOT NULL,
    sensor_description  VARCHAR(120) NULL,
    PRIMARY KEY (sensor_id),
    UNIQUE KEY id (sensor_id)
);

CREATE TABLE sensor_reading (
    sensor_id   VARCHAR(20) NOT NULL,
    read_time   TIMESTAMP NOT NULL,
    temp        DECIMAL(5,2) NOT NULL,
    humidity    DECIMAL(5,2) NULL,
    pressure    DECIMAL(5,2) NULL,
    PRIMARY KEY (sensor_id,read_time)
);

CREATE TABLE sensor_summary (
    record_no       INT NOT NULL AUTO_INCREMENT,
    sensor_id       VARCHAR(20) NOT NULL,
    read_date       DATE NOT NULL,
    read_hour       INT NOT NULL,
    read_count      INT NOT NULL,
    sum_temp        DECIMAL(8,2) NOT NULL,
    sum_humidity    DECIMAL(8,2) NULL,
    sum_pressure    DECIMAL(8,2) NULL,
    PRIMARY KEY (record_no),
    UNIQUE KEY pk_sensor_summary (sensor_id,read_date,read_hour)
);

CREATE VIEW sensor_report AS 
SELECT 
    ss.sensor_id AS sensor_id,
    si.sensor_name AS sensor_name,
    (ss.read_date + interval ss.read_hour hour) AS read_datetime,
    ss.read_date AS read_date,
    ss.read_hour AS read_hour,
    (ss.sum_temp / ss.read_count) AS avg_temp,
    (ss.sum_humidity / ss.read_count) AS avg_humidity,
    (ss.sum_pressure / ss.read_count) AS avg_pressure 
FROM (sensor_summary ss 
JOIN sensor_info si on((ss.sensor_id = si.sensor_id)));

# --- !Ups
CREATE TABLE IF NOT EXISTS user (
  id   	     	    	    INT PRIMARY KEY AUTO_INCREMENT,
  email                     VARCHAR(255) NOT NULL,
  name_first                VARCHAR(255) NOT NULL,
  name_last    		    VARCHAR(255) NOT NULL,
  password                  VARCHAR(255) NOT NULL,
  birthday		    DATE,
  gender		    VARCHAR(1) NOT NULL,
  country		    VARCHAR(32) NOT NULL,
  container_list_number	    INT NOT NULL
);

CREATE TABLE IF NOT EXISTS monitor (
  id                        INT PRIMARY KEY AUTO_INCREMENT,
  manufacturer		    VARCHAR(255) NOT NULL,
  name                      VARCHAR(255) NOT NULL,
  product_id		    INT NOT NULL,
  vendor_id		    INT NOT NULL
);

CREATE TABLE IF NOT EXISTS container (
  id                        INT PRIMARY KEY AUTO_INCREMENT,
  name                      VARCHAR(255) NOT NULL,
  temperature_expected	    DOUBLE,
  temperature_range	    DOUBLE,
  read_frequency 	    INT,
  monitor_id		    INT,
  last_read_temperature	    DOUBLE,
  last_read_status	    VARCHAR(255),
  last_read_time	    DATETIME
) ENGINE=INNODB;

CREATE TABLE IF NOT EXISTS container_list (
  entry_number 	    	   INT PRIMARY KEY AUTO_INCREMENT,
  list_number 		   INT NOT NULL,
  container_index	   INT NOT NULL,
  container_id 		   INT NOT NULL,
  FOREIGN KEY(container_id) 
    REFERENCES container(id) 
    ON DELETE CASCADE
) ENGINE=INNODB;

CREATE TABLE IF NOT EXISTS container_readings (
  reading_id    	   INT PRIMARY KEY AUTO_INCREMENT,
  container_id 		   INT NOT NULL,
  read_temperature 	   DOUBLE,
  read_status 		   VARCHAR(255) NOT NULL,
  read_time 		   TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  read_note		   VARCHAR(1023),
  FOREIGN KEY(container_id) 
    REFERENCES container(id) 
    ON DELETE CASCADE
) ENGINE=INNODB;

# --- !Downs
DROP TABLE IF EXISTS container_list;
DROP TABLE IF EXISTS container_readings;
DROP TABLE IF EXISTS user;
DROP TABLE IF EXISTS container;
DROP TABLE IF EXISTS monitor;



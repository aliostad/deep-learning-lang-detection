DROP TABLE Customer;
CREATE TABLE Customer (customerId varchar(20) NOT NULL, name VARCHAR(32) NOT NULL, address VARCHAR(200) NULL, CONSTRAINT customer_pk PRIMARY KEY (customerId) );
INSERT INTO Customer (customerId, name, address) values ('10001', 'Stefano', 'New Home' );
INSERT INTO Customer (customerId, name, address ) values ('10002', 'Luca', 'Luca place' );
INSERT INTO Customer (customerId, name, address) values ('10003', 'Tiago', 'Another address' );
INSERT INTO Customer (customerId, name, address) values ('10004', 'Antonios', 'home' );
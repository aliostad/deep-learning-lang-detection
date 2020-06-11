DROP DATABASE IF EXISTS mview_demo;
CREATE DATABASE mview_demo;
USE mview_demo;

DROP TABLE IF EXISTS mview_demo.customer;

CREATE TABLE mview_demo.customer (
  customer_id   INTEGER NOT NULL,
  customer_name VARCHAR(255) NOT NULL,
  PRIMARY KEY (customer_id)
);

DROP TABLE IF EXISTS customer_payment;

CREATE TABLE mview_demo.customer_payment (
  payment_id INTEGER NOT NULL AUTO_INCREMENT,
  customer_id INTEGER NOT NULL,
  payment DECIMAL(12,4),
  PRIMARY KEY (payment_id),
  KEY idx_customer_payment_customer_id (customer_id)
);

INSERT INTO mview_demo.customer (customer_id, customer_name) VALUES (1, 'Tyrone C. Johnson');
INSERT INTO mview_demo.customer (customer_id, customer_name) VALUES (2, 'Soo L. Cordova');
INSERT INTO mview_demo.customer (customer_id, customer_name) VALUES (3, 'William J. Milner');
INSERT INTO mview_demo.customer (customer_id, customer_name) VALUES (4, 'Loretta C. Watson');
INSERT INTO mview_demo.customer (customer_id, customer_name) VALUES (5, 'Guillermo J. Hubbard');

INSERT INTO mview_demo.customer_payment (customer_id, payment) VALUES (1, 100.00);
INSERT INTO mview_demo.customer_payment (customer_id, payment) VALUES (1, 15.07);
INSERT INTO mview_demo.customer_payment (customer_id, payment) VALUES (1, 39.00);
INSERT INTO mview_demo.customer_payment (customer_id, payment) VALUES (2, 45.00);
INSERT INTO mview_demo.customer_payment (customer_id, payment) VALUES (2, 37.15);
INSERT INTO mview_demo.customer_payment (customer_id, payment) VALUES (3, 23.47);
INSERT INTO mview_demo.customer_payment (customer_id, payment) VALUES (3, 39.30);
INSERT INTO mview_demo.customer_payment (customer_id, payment) VALUES (3, 674.35);
INSERT INTO mview_demo.customer_payment (customer_id, payment) VALUES (3, -100.00);
INSERT INTO mview_demo.customer_payment (customer_id, payment) VALUES (4, 213.10);
INSERT INTO mview_demo.customer_payment (customer_id, payment) VALUES (4, 4.35);
INSERT INTO mview_demo.customer_payment (customer_id, payment) VALUES (4, -15.00);
INSERT INTO mview_demo.customer_payment (customer_id, payment) VALUES (4, 89.08);
INSERT INTO mview_demo.customer_payment (customer_id, payment) VALUES (5, 45.19);
INSERT INTO mview_demo.customer_payment (customer_id, payment) VALUES (5, -30.00);

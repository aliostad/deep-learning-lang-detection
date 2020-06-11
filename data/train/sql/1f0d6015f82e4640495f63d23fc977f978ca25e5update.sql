CREATE TABLE airlines_new LIKE airlines;
LOAD DATA INFILE '/tmp/iana/database/airlines.dat' INTO TABLE airlines_new FIELDS TERMINATED BY ',' ENCLOSED BY '"' ESCAPED BY '\\';
RENAME TABLE airlines TO airlines_tmp, airlines_new TO airlines;
DROP TABLE airlines_tmp;

CREATE TABLE airports_new LIKE airports;
LOAD DATA INFILE '/tmp/iana/database/airports.dat' INTO TABLE airports_new FIELDS TERMINATED BY ',' ENCLOSED BY '"' ESCAPED BY '\\';
RENAME TABLE airports TO airports_tmp, airports_new TO airports;
DROP TABLE airports_tmp;

CREATE TABLE routes_new LIKE routes;
LOAD DATA INFILE '/tmp/iana/database/routes.dat' INTO TABLE routes_new FIELDS TERMINATED BY ',' ESCAPED BY '\\'
(airline, airline_id, source_airport, source_airport_id, destination_airport, destination_airport_id, codeshare, stops, equipment);
RENAME TABLE routes TO routes_tmp, routes_new TO routes;
DROP TABLE routes_tmp;


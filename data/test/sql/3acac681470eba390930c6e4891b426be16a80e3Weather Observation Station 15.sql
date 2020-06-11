/*
Problem Statement

Given a table STATION that holds data for five fields namely ID, CITY, STATE, NORTHERN LATITUDE and WESTERN LONGITUDE.
+-------------+------------+
| Field       |   Type     |
+-------------+------------+
| ID          | INTEGER    |
| CITY        | VARCHAR(21)|
| STATE       | VARCHAR(2) |
| LAT_N       | NUMERIC    |
| LONG_W      | NUMERIC    |
+-------------+------------+

Write a query to find the corresponding Western Longitude value for the greatest value of the Northern Latitudes less than 137.2345 up to 4 decimal places.
*/

/*
Enter your query here.
Please append a semicolon ";" at the end of the query and enter your query in a single line to avoid error.
*/
select top 1 cast(long_w as numeric(10,4))
from station
where cast(lat_n as numeric(10,4)) < 137.2345
order by lat_n desc;

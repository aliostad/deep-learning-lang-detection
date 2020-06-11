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

Consider P1(a, b) and P2(c, d) be two points on 2D plane, where (a, b) be minimum and maximum values of Northern Latitude and (c, d) be minimum and maximum values of Western Longitude. Write a query to print the Manhattan Distance between points P1 and P2 up to 4 decimal digits.
*/

/*
Enter your query here.
Please append a semicolon ";" at the end of the query and enter your query in a single line to avoid error.
*/
--use the distance formula: sqrt((x2-x1)^2+(y2-y1)^2)
--select cast(
--        (sqrt(
--            (square((min(long_w)-min(lat_n))) + square((max(long_w)-max(lat_n))))
--            )) as numeric(10,4))
--from station

--use the Manhattan distance formula: | p_1 - q_1 | + | p_2 - q_2 |
select cast(
    (abs((min(long_w)-min(lat_n))) + abs((max(long_w)-max(lat_n))))
            as numeric(10,4))
from station

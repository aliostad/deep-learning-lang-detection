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

Print the median of Northern Latitude values up to 4 decimal places.
*/

/*
Enter your query here.
Please append a semicolon ";" at the end of the query and enter your query in a single line to avoid error.
*/
--counting rows
declare @c bigint = (select count(lat_n) from station);

select cast(lat_n as numeric(10,4))
from(
select  lat_n
        ,row_number() over(order by lat_n) as row
from station
    ) as a
where a.row = ((@c+1) / 2)

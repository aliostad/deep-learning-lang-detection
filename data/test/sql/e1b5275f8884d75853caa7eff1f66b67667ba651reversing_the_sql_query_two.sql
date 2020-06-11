/*
Enter your query here.
Please append a semicolon ";" at the end of the query and enter your query in a single line to avoid error.

Given a City table, whose fields are described as

+-------------+----------+
| Field       | Type     |
+-------------+----------+
| ID          | int(11)  |
| Name        | char(35) |
| CountryCode | char(3)  |
| District    | char(20) |
| Population  | int(11)  |
+-------------+----------+
Write a query that will fetch all the city Names for every row in the table where the CountryCode = 'USA' (i.e, we wish to retreive data for all American cities) and their population exceeds 120000.

Language: MS SQL Server
*/

select Name from City
    where CountryCode like 'USA'
    and Population > 120000; 
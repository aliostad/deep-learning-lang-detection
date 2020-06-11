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
write a query that will fetch all columns for every row in the table where the CountryCode = 'USA' (i.e, we wish to retreive data for all American cities) and the population exceeds 100,000.

Language: MS SQL Server


*/
select * from City where CountryCode LIKE 'USA' and Population>100000; 

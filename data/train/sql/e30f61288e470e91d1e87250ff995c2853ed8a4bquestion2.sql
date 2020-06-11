SELECT Employee.ssnum
FROM Employee
WHERE Employee.name = 'Smith'
OR Employee.dept = 'acquisitions';

SELECT * FROM (( SELECT Employee.ssnum
 FROM Employee
 WHERE Employee.name = 'Smith' )
UNION (
 SELECT Employee.ssnum
 FROM Employee
 WHERE Employee.dept = 'acquisitions'
)) AS foo;

/*
0.00108218193054199
0.00128984451293945

Both of the queries return the same result.
Marginal difference in time, with the UNION statement slower, because it runs two queries.

The first query does one sequential scan, matching each row against two conditions
"SELECT Employee.ssnum\nFROM Employee\nWHERE Employee.name = 'Smith'\nOR Employee.dept = 'acquisitions'"
QUERY PLANSeq Scan on employee  (cost=0.00..25.00 rows=88 width=8)
QUERY PLAN  Filter: (((name)::text = 'Smith'::text) OR ((dept)::text = 'acquisitions'::text))
{"ssnum"=>"45"}

The second query takes longer, needing to run two sequential scans, and a sort.
"( SELECT Employee.ssnum\n FROM Employee\n WHERE Employee.name = 'Smith' )\nUNION (\n SELECT Employee.ssnum\n FROM Employee\n WHERE Employee.dept = 'acquisitions'\n)"
QUERY PLANUnique  (cost=48.72..49.16 rows=88 width=8)
QUERY PLAN  ->  Sort  (cost=48.72..48.94 rows=88 width=8)
QUERY PLAN        Sort Key: public.employee.ssnum
QUERY PLAN        ->  Append  (cost=0.00..45.88 rows=88 width=8)
QUERY PLAN              ->  Seq Scan on employee  (cost=0.00..22.50 rows=2 width=8)
QUERY PLAN                    Filter: ((name)::text = 'Smith'::text)
QUERY PLAN              ->  Seq Scan on employee  (cost=0.00..22.50 rows=86 width=8)
QUERY PLAN                    Filter: ((dept)::text = 'acquisitions'::text)

*/

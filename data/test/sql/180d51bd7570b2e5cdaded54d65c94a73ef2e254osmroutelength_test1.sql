CREATE OR REPLACE FUNCTION test1(source int, target int, tablename text)
RETURNS setof record
AS
$$
import psycopg2
import osgeo.ogr
import math
statement1 = ("select count(*) from pgr_dijkstra(' SELECT gid AS id, source::integer, target::integer, length_dem::double precision AS cost FROM %s', %s, %s, false, false) a LEFT JOIN %s b ON (a.id2 = b.gid)" % (tablename, source, target, tablename))
statement2 = ("select seq, id1 AS node, id2 AS edge, cost, b.the_geom, b.source, b.target, b.slope_st_pt, b.slope_end_pt from pgr_dijkstra(' SELECT gid AS id, source::integer, target::integer, length_dem::double precision AS cost FROM %s', %s, %s, false, false) a LEFT JOIN %s b ON (a.id2 = b.gid)" % (tablename, source, target, tablename))
count1 = plpy.execute(statement1)
run2 = plpy.execute(statement2)
len1 = count1[0]['count']
row1 = [];
for i in range(len1):
if run2[i]['node']==run2[i]['source']:
row1.append(run2[i])
elif run2[i]['node']==run2[i]['target']:
row1.append(run2[i])
return row1;
$$
LANGUAGE 'plpythonu' VOLATILE;
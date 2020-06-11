drop table plz_roads;

create table plz_roads (
  id bigint,
  street  text,
  zipcode  text,
  way geometry(LineString,900913)
);

insert into plz_roads (id,street,zipcode,way)

SELECT
  d3.id,
  d3.strasse,
  d3.zipcode,
  d3.simple_geom
FROM (
  select
    d.*,
    (d.geom_dump).geom as simple_geom,
    (d.geom_dump).path as path
  from (
    SELECT
      *,
      ST_Dump(rway) AS geom_dump
    from (
      select

        roads.osm_id as id,
        roads.name as strasse,
        plz.zipcode,
        ST_Intersection(roads.simple_geom,plz.way) as rway

      from


        (select way,tags::hstore->'postal_code' as zipcode from planet_osm_polygon
        where boundary = 'postal_code'
        ) as plz

        INNER JOIN

        (
          SELECT
            dumped.*,
            (dumped.geom_dump).geom as simple_geom,
            (dumped.geom_dump).path as path
          FROM (
            SELECT *, ST_Dump(way) AS geom_dump FROM planet_osm_line where highway in (
              'secondary',
              'primary',
              'service',
              'steps',
              'residential',
              'living_street',
              'footway'
            ) and name <> ''
          ) as dumped
        ) as roads
        ON ST_Intersects(plz.way,roads.way)
    ) d2
  ) d
) d3
where ST_GeometryType(simple_geom)='ST_LineString'
;




insert into plz_roads (id,street,zipcode,way)

SELECT
  d3.id,
  d3.strasse,
  d3.zipcode,
  d3.simple_geom
FROM (
  select
    d.*,
    (d.geom_dump).geom as simple_geom,
    (d.geom_dump).path as path
  from (
    SELECT
      *,
      ST_Dump(rway) AS geom_dump
    from (
      select

        roads.osm_id as id,
        roads.name as strasse,
        plz.zipcode,
        ST_Intersection(roads.simple_geom,plz.way) as rway

      from


        (select way,tags::hstore->'postal_code' as zipcode from planet_osm_polygon
        where boundary = 'postal_code'
        ) as plz

        INNER JOIN

        (
          SELECT
            dumped.*,
            (dumped.geom_dump).geom as simple_geom,
            (dumped.geom_dump).path as path
          FROM (
            SELECT *, ST_Dump(way) AS geom_dump FROM planet_osm_roads where highway in (
              'secondary',
              'primary',
              'service',
              'steps',
              'residential',
              'living_street',
              'footway'
            ) and name <> ''
          ) as dumped
        ) as roads
        ON ST_Intersects(plz.way,roads.way)
    ) d2
  ) d
) d3
where ST_GeometryType(simple_geom)='ST_LineString'
;

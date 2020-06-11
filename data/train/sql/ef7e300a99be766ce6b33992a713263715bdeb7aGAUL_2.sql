
-- ogr2ogr -f postgresql -skipfailures -update -append -nlt MULTIPOLYGON PG:"dbname='gis' host='168.202.25.219' port='5432' user='postgres' password='postgres'" ../GAUL/g2013_2012_2/g2013_2012_2/G2013_2012_2.shp
--DELETE FROM g2013_2012_2
DROP TABLE g2013_2012_2;
-- NOW change geometry to generic Geometry (http://trac.osgeo.org/gdal/ticket/4939)
CREATE TABLE g2013_2012_2
(
  ogc_fid serial NOT NULL,
  wkb_geometry geometry(MultiPolygon,4326),
  status character varying(37),
  str_year numeric(9,0),
  exp_year numeric(9,0),
  disp_area character varying(3),
  adm0_code numeric(9,0),
  adm0_name character varying(100),
  shape_leng numeric(19,11),
  shape_area numeric(19,11),
  CONSTRAINT g2013_2012_2_pk PRIMARY KEY (ogc_fid)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE g2013_2012_2
  OWNER TO postgres;

-- Index: g2013_2012_2_geom_idx

-- DROP INDEX g2013_2012_2_geom_idx;

CREATE INDEX g2013_2012_2_geom_idx
  ON g2013_2012_2
  USING gist
  (wkb_geometry);

-- now start again ingestion
-- ogr2ogr -f postgresql -skipfailures -update -append -nlt MULTIPOLYGON PG:"dbname='gis' host='168.202.25.219' port='5432' user='postgres' password='postgres'" ../GAUL/g2013_2012_2/g2013_2012_2/G2013_2012_2.shp

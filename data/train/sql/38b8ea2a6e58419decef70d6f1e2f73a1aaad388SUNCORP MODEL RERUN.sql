-- SUNCORP MODEL RERUN
-- PREPARE THE DATASET
-- Take Residuals at customer level and roll up to meshblock



--
--	APPEND POINT GEOMETRY TO "<your new table>"
--
alter table "<your new table>"
add  claim_point geometry;

update "<your new table>"
set claim_point = ST_SetSRID(ST_MakePoint(longitude,latitude), 4283)
where claim_point is null;

CREATE INDEX "<your new table>"_geom_pt ON "<your new table>" USING GIST(claim_point);


alter table "<your new table>"
add mb_code_20  VARCHAR(50);

-- ADD MESHBLOCK CODE TO TABLE
UPDATE "<your new table>" a
SET mb_code_20 = b.mb_code_20
FROM raw_abs_mb11_4283  b
WHERE st_intersects(a.claim_point, b.geometry)
and a.mb_code_20 is null;



--
--	CALCULATE RESIDUALS PER MESHBLOCK
--
create table DRV_RESIDUALS as
Select 	
	a.mb_code_20
	,sum( residual ) as residual
from "<your new table>" a
group by a.mb_code_20
;

--
-- 	ADD RESIDUAL TO DRV_RESIDUALS
--
ALTER TABLE DRV_DATA_MODELLING
ADD residual float;


update a
set residual = b.residual
from DRV_DATA_MODELLING a
left join DRV_RESIDUALS b  on a.recid = b.mb_code_20
where residual is null;


--
--	EXPORT AS CSV
--

-- Open a Postgres command line and run this command at the prompt
-- SuncorpGeodata2017=# SuncorpGeodata2017=# COPY DRV_DATA_MODELLING TO 'F:/aszwec/data/DRV_DATA_MODELLING.csv' DELIMITER ',' CSV HEADER;



--
--	NOW RUN R CODE 
--

-- Run file CODE FILE: "F:\aszwec\R\suncorp_model_v008.r"





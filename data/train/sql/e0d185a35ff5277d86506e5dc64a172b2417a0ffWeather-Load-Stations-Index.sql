 -- Name of database
use vizsagedb_weather; 

-- =========================================================================
--
--	Impose Indices
--
-- =========================================================================

ALTER TABLE StationInfoISH \
	ADD INDEX				(name)	
 ,	ADD INDEX				(region)	
 ,	ADD INDEX				(country)	
 ,	ADD INDEX				(state)	
 ,	ADD INDEX				(callsign)
 ,	ADD INDEX				(lat)		
 ,	ADD INDEX				(lng)		
 ,	ADD INDEX				(elev)
 ;
 SHOW COUNT(*) WARNINGS; SHOW COUNT(*) ERRORS; SHOW WARNINGS; SHOW ERRORS;


ALTER TABLE StationInfoCOOP \
	ADD INDEX				(id_COOP)
 ,	ADD INDEX				(id_cd)
-- ,ADD INDEX				(id_NCDC)
 ,	ADD INDEX				(id_WMO)	
 ,	ADD INDEX				(id_FAA)	
 ,	ADD INDEX				(id_NWS)
 ,	ADD INDEX				(id_ICAO)
 ,	ADD INDEX				(country)
 ,	ADD INDEX				(state)
 ,	ADD INDEX				(uscounty)
 ,	ADD INDEX				(tz)
 ,	ADD INDEX				(name_coop)
 ,	ADD INDEX				(name)
 ,	ADD INDEX				(svc_beg)
 ,	ADD INDEX				(svc_end)
 ,	ADD INDEX				(lat)	
 ,	ADD INDEX				(lng)	
 ,	ADD INDEX				(elevgd)
 ,	ADD INDEX				(elev)
 ;
 SHOW COUNT(*) WARNINGS; SHOW COUNT(*) ERRORS; SHOW WARNINGS; SHOW ERRORS;


ALTER TABLE StationHistISH \
	ADD INDEX				(year)
 ,	ADD INDEX				(month)
 ,	ADD INDEX				(n_records)
 ;
 SHOW COUNT(*) WARNINGS; SHOW COUNT(*) ERRORS; SHOW WARNINGS; SHOW ERRORS;

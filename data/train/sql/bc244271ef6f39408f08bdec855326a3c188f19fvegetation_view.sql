-- View: plantdb_vegetationview

-- DROP VIEW plantdb_vegetationview;

CREATE OR REPLACE VIEW plantdb_vegetationview AS 
 SELECT plantdb_vegetationview.row_number,
    plantdb_vegetationview.vegetationid,
    plantdb_vegetationview.plantid,
    plantdb_vegetationview.rootstockid,
    plantdb_vegetationview.cultivarid,
    plantdb_vegetationview.legacy_pfaf_latin_name,
    plantdb_vegetationview.family,
    plantdb_vegetationview.genus,
    plantdb_vegetationview.species,
    plantdb_vegetationview.ssp,
    plantdb_vegetationview.common_name,
    plantdb_vegetationview.plant_function,
    plantdb_vegetationview.border_colour,
    plantdb_vegetationview.fill_colour,
    plantdb_vegetationview.symbol,
    plantdb_vegetationview.form,
    plantdb_vegetationview.locations,
    plantdb_vegetationview.width,
    plantdb_vegetationview.height,
    plantdb_vegetationview.grafted,
    plantdb_vegetationview.comment,
    plantdb_vegetationview.germination_date,
    plantdb_vegetationview.habitat,
    plantdb_vegetationview.wind_lower_limit,
    plantdb_vegetationview.wind_upper_limit,
    plantdb_vegetationview.light_lower_limit,
    plantdb_vegetationview.light_upper_limit,
    plantdb_vegetationview.nitrogen_fixer,
    plantdb_vegetationview.supports_wildlife,
    plantdb_vegetationview.flower_type,
    plantdb_vegetationview.pollinators,
    plantdb_vegetationview.self_fertile,
    plantdb_vegetationview.pollution,
    plantdb_vegetationview.cultivation_details,
    plantdb_vegetationview.known_hazards,
    plantdb_vegetationview.cultivarname,
    plantdb_vegetationview.notes_on_cultivar,
    plantdb_vegetationview.synonyms,
    plantdb_vegetationview.scented,
    plantdb_vegetationview.wind_tolerance,
    plantdb_vegetationview.hardiness,
    plantdb_vegetationview.range,
    plantdb_vegetationview.frost_tender,
    plantdb_vegetationview.production_startmonth,
    plantdb_vegetationview.production_endmonth,
    plantdb_vegetationview.leaf_startmonth,
    plantdb_vegetationview.leaf_endmonth,
    plantdb_vegetationview.flower_startmonth,
    plantdb_vegetationview.flower_endmonth,
    plantdb_vegetationview.seed_start_month,
    plantdb_vegetationview.seed_endmonth,
    plantdb_vegetationview.rootstockname,
    plantdb_vegetationview.notes_on_rootstock,
    plantdb_vegetationview.vigour,
    plantdb_vegetationview."pH_lower_limit",
    plantdb_vegetationview."pH_upper_limit",
    plantdb_vegetationview.salinity_lower_limit,
    plantdb_vegetationview.salinity_upper_limit,
    plantdb_vegetationview.moisture_lower_limit,
    plantdb_vegetationview.moisture_upper_limit,
    plantdb_vegetationview.soiltexture_lower_limit,
    plantdb_vegetationview.soiltexture_upper_limit
   FROM ( SELECT row_number() OVER (ORDER BY plantdb_vegetation.id) AS row_number,
            plantdb_vegetation.id AS vegetationid,
            plantdb_plant.id AS plantid,
            plantdb_plant.legacy_pfaf_latin_name,
            plantdb_plant.family,
            plantdb_plant.genus,
            plantdb_plant.species,
            plantdb_plant.ssp,
            plantdb_plant.common_name,
            plantdb_plant.plant_function,
            plantdb_plant.border_colour,
            plantdb_plant.fill_colour,
            plantdb_plant.symbol,
            plantdb_plant.form,
            plantdb_vegetation.locations,
            plantdb_rootstock.id AS rootstockid,
            plantdb_rootstock.height,
            plantdb_rootstock.width,
            plantdb_cultivar.id AS cultivarid,
            plantdb_cultivar.production_startmonth,
            plantdb_cultivar.production_endmonth,
            plantdb_vegetation.grafted,
            plantdb_vegetation.comment,
            plantdb_vegetation.germination_date,
            
            plantdb_plant.habitat,
            plantdb_plant.wind_lower_limit,
            plantdb_plant.wind_upper_limit,
            plantdb_plant.light_lower_limit,
            plantdb_plant.light_upper_limit,
            plantdb_plant.nitrogen_fixer,
            plantdb_plant.supports_wildlife,
            plantdb_plant.flower_type,
            plantdb_plant.pollinators,
            plantdb_plant.self_fertile,
            plantdb_plant.pollution,
            plantdb_plant.cultivation_details,
            plantdb_plant.known_hazards,

            plantdb_cultivar.name AS cultivarname,
            plantdb_cultivar.notes_on_cultivar,
            plantdb_cultivar.synonyms,
            plantdb_cultivar.scented,
            plantdb_cultivar.wind_tolerance,
            plantdb_cultivar.hardiness,
            plantdb_cultivar.range,
            plantdb_cultivar.frost_tender,
            plantdb_cultivar.leaf_startmonth,
            plantdb_cultivar.leaf_endmonth,
            plantdb_cultivar.flower_startmonth,
            plantdb_cultivar.flower_endmonth,
            plantdb_cultivar.seed_start_month,
            plantdb_cultivar.seed_endmonth,

            plantdb_rootstock.rootstockname,
            plantdb_rootstock.notes_on_rootstock,
            plantdb_rootstock.vigour,
            plantdb_rootstock."pH_lower_limit",
            plantdb_rootstock."pH_upper_limit",
            plantdb_rootstock.salinity_lower_limit,
            plantdb_rootstock.salinity_upper_limit,
            plantdb_rootstock.moisture_lower_limit,
            plantdb_rootstock.moisture_upper_limit,
            plantdb_rootstock.soiltexture_lower_limit,
            plantdb_rootstock.soiltexture_upper_limit
            
           FROM plantdb_vegetation
             LEFT JOIN plantdb_plant ON plantdb_vegetation.plant_id = plantdb_plant.id
             LEFT JOIN plantdb_cultivar ON plantdb_vegetation.cultivar_id = plantdb_cultivar.id
             LEFT JOIN plantdb_rootstock ON plantdb_vegetation.rootstock_id = plantdb_rootstock.id) plantdb_vegetationview;

ALTER TABLE plantdb_vegetationview
  OWNER TO postgres;
GRANT ALL ON TABLE plantdb_vegetationview TO postgres;
GRANT ALL ON TABLE plantdb_vegetationview TO public;
COMMENT ON VIEW plantdb_vegetationview
  IS '-- View: plantdb_vegetationview';

-- Rule: view_delete ON plantdb_vegetationview

-- DROP RULE view_delete ON plantdb_vegetationview;

CREATE OR REPLACE RULE view_delete AS
    ON DELETE TO plantdb_vegetationview DO INSTEAD  DELETE FROM plantdb_vegetation
  WHERE plantdb_vegetation.id = old.vegetationid;

-- Rule: view_insert ON plantdb_vegetationview

-- DROP RULE view_insert ON plantdb_vegetationview;

CREATE OR REPLACE RULE view_insert AS
    ON INSERT TO plantdb_vegetationview DO INSTEAD  INSERT INTO plantdb_vegetation (plant_id, cultivar_id, rootstock_id, locations, grafted, comment, germination_date)
  VALUES (new.plantid, new.cultivarid, new.rootstockid, new.locations, new.grafted, new.comment, new.germination_date);

-- Rule: view_update ON plantdb_vegetationview

-- DROP RULE view_update ON plantdb_vegetationview;

CREATE OR REPLACE RULE view_update AS
    ON UPDATE TO plantdb_vegetationview DO INSTEAD ( 
    UPDATE plantdb_vegetation 
      SET plant_id = new.plantid, 
        cultivar_id = new.cultivarid, 
        rootstock_id = new.rootstockid, 
        locations = new.locations, 
        grafted = new.grafted, 
        comment = new.comment, 
        germination_date = new.germination_date
      WHERE plantdb_vegetation.id = new.vegetationid;
    UPDATE plantdb_plant
      SET form = new.form,
        symbol = new.symbol,
	plant_function = new.plant_function,
	habitat = new.habitat,
	wind_lower_limit = new.wind_lower_limit,
        wind_upper_limit = new.wind_upper_limit,
        light_lower_limit = new.light_lower_limit,
        light_upper_limit = new.light_upper_limit,
        nitrogen_fixer = new.nitrogen_fixer,
        supports_wildlife = new.supports_wildlife,
        cultivation_details = new.cultivation_details,
        known_hazards = new.known_hazards,
        self_fertile = new.self_fertile,
        pollution = new.pollution
      WHERE plantdb_plant.id = new.plantid;
    UPDATE plantdb_rootstock 
      SET height = new.height,
        width = new.width,
        notes_on_rootstock = new.notes_on_rootstock,
        moisture_lower_limit = new.moisture_lower_limit,
        moisture_upper_limit = new.moisture_upper_limit,
        soiltexture_lower_limit = new.soiltexture_lower_limit,
        soiltexture_upper_limit = new.soiltexture_upper_limit,
        "pH_lower_limit" = new."pH_lower_limit",
        "pH_upper_limit" = new."pH_upper_limit",
        salinity_lower_limit = new.salinity_lower_limit,
        salinity_upper_limit = new.salinity_upper_limit
      WHERE plantdb_rootstock.id = new.rootstockid AND
	new.rootstockid = old.rootstockid;
    UPDATE plantdb_cultivar 
      SET notes_on_cultivar = new.notes_on_cultivar,
	production_startmonth = new.production_startmonth,
        production_endmonth = new.production_endmonth,
	leaf_startmonth = new.leaf_startmonth,
        leaf_endmonth = new.leaf_endmonth,
        flower_startmonth = new.flower_startmonth,
        flower_endmonth = new.flower_endmonth,
        seed_start_month = new.seed_start_month,
        seed_endmonth = new.seed_endmonth,
        range = new.range
      WHERE plantdb_cultivar.id = new.cultivarid AND
        new.cultivarid = old.cultivarid;
);
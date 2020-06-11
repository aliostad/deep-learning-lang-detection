-- --------------------------------------------------------
-- Copyright (c) 2013 Matthew Pate and Daniel Catalano
-- [This program is licensed under the "MIT License"]
-- Please see the file COPYING in the source distribution
-- of this software for license terms.
-- --------------------------------------------------------

\c stormking
CREATE EXTENSION postgis;

CREATE TABLE model_run (
  model_run_date date NOT NULL,
  model_run_time timetz NOT NULL,
  model_run_pkey SERIAL PRIMARY KEY,
  UNIQUE (model_run_date, model_run_time)
);

CREATE TABLE forecast_hour (
  forecast_hour interval NOT NULL,
  forecast_hour_pkey SERIAL PRIMARY KEY,
  UNIQUE (forecast_hour)
);

CREATE TABLE model_forecast_relation (
  model_run_pkey integer NOT NULL REFERENCES model_run (model_run_pkey),
  forecast_hour_pkey integer NOT NULL REFERENCES forecast_hour (forecast_hour_pkey),
  model_forecast_relation_pkey SERIAL PRIMARY KEY,
  UNIQUE (model_run_pkey, forecast_hour_pkey)
);

CREATE TABLE met_param (
  level smallint NOT NULL, 
  level_unit text NOT NULL, 
  attribute text NOT NULL, 
  attribute_unit text NOT NULL, 
  met_param_pkey SERIAL PRIMARY KEY,
  UNIQUE (level, attribute)
);

CREATE TABLE region (
  region_name text NOT NULL,
  region_abbv text UNIQUE NOT NULL,
  fs_region_num smallint NOT NULL,
  region_pkey SERIAL PRIMARY KEY
);

-- TODO create uniqueness in region_ref_number & regional_grid
CREATE TABLE model_grid_points (
  model_grid_points_pkey SERIAL PRIMARY KEY, 
  region_pkey smallint NOT NULL REFERENCES region (region_pkey),
  region_ref_number smallint NOT NULL, 
  regional_grid text,
  national_ref_number smallint UNIQUE, 
  location bigint -- TODO replace "bigint" with "geography(POINT,4326)"
);

CREATE TABLE met_data ( 
    value real NOT NULL,
    met_data_pkey SERIAL PRIMARY KEY, 
    met_param_pkey smallint NOT NULL REFERENCES met_param (met_param_pkey),
    model_grid_points_pkey integer NOT NULL REFERENCES model_grid_points (model_grid_points_pkey), 
    model_forecast_relation_pkey integer NOT NULL REFERENCES model_forecast_relation (model_forecast_relation_pkey) 
);
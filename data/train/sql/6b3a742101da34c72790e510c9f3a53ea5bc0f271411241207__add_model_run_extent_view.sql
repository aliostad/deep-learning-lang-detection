-- Updates the database schema to add a view of the model_run_admin_unit_disease_extent_class table in a form that is ready for use with GeoServer and CQL filters.
-- Copyright (c) 2014 University of Oxford

-- A view of the model_run_admin_unit_disease_extent_class table in a form that is ready for use with GeoServer and CQL filters
CREATE VIEW model_run_extent_view
AS
SELECT
    model_run.name AS model_run_name,
    model_run_extent.disease_extent_class AS disease_extent_class,
    COALESCE(admin_unit_global.geom, admin_unit_tropical.geom) AS admin_unit_geom
FROM model_run_admin_unit_disease_extent_class AS model_run_extent
INNER JOIN model_run ON model_run_extent.model_run_id = model_run.id
LEFT OUTER JOIN admin_unit_global ON model_run_extent.global_gaul_code = admin_unit_global.gaul_code
LEFT OUTER JOIN admin_unit_tropical ON model_run_extent.tropical_gaul_code = admin_unit_tropical.gaul_code;

GRANT SELECT ON model_run_extent_view TO ${application_username};
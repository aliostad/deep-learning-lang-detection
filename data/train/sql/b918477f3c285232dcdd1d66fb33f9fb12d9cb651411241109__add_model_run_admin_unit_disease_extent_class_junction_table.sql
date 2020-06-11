-- Updates the database schema to add a many-to-many junction table between model_run, admin_unit (global/tropical) and disease_extent_class.
-- Copyright (c) 2014 University of Oxford

-- Represents the mapping of admin units to disease extent classes which were submitted for modelling for each model run.
CREATE TABLE model_run_admin_unit_disease_extent_class (
    id serial
        CONSTRAINT pk_model_run_admin_unit_disease_extent_class PRIMARY KEY,
    model_run_id integer NOT NULL
        CONSTRAINT fk_model_run_admin_unit_disease_extent_class_model_run REFERENCES model_run (id),
    global_gaul_code integer
        CONSTRAINT fk_model_run_admin_unit_disease_extent_class_admin_unit_global REFERENCES admin_unit_global (gaul_code),
    tropical_gaul_code integer
        CONSTRAINT fk_model_run_admin_unit_disease_extent_class_admin_unit_tropical REFERENCES admin_unit_tropical (gaul_code),
    disease_extent_class varchar(20) NOT NULL
        CONSTRAINT fk_model_run_admin_unit_disease_extent_class_disease_extent_class REFERENCES disease_extent_class (name),
    CONSTRAINT ck_global_gaul_code_tropical_gaul_code CHECK ((global_gaul_code IS NULL AND tropical_gaul_code IS NOT NULL) OR (global_gaul_code IS NOT NULL AND tropical_gaul_code IS NULL))
);

CREATE INDEX ix_model_run_admin_unit_disease_extent_class ON model_run_admin_unit_disease_extent_class (model_run_id);

GRANT SELECT, INSERT ON model_run_admin_unit_disease_extent_class TO ${application_username};
GRANT SELECT, UPDATE ON model_run_admin_unit_disease_extent_class_id_seq TO ${application_username};
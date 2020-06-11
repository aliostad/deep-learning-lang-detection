-- Updates the database schema to add a many-to-many junction table between model_run and disease_occurrence.
-- Copyright (c) 2014 University of Oxford

-- Represents the collection of disease_occurrence ids which were submitted for modelling for each model_run id.
CREATE TABLE model_run_disease_occurrence (
    model_run_id integer NOT NULL
        CONSTRAINT fk_model_run_disease_occurrence_model_run REFERENCES model_run (id),
    disease_occurrence_id integer NOT NULL
        CONSTRAINT fk_model_run_disease_occurrence_disease_occurrence REFERENCES disease_occurrence (id),
    CONSTRAINT pk_model_run_disease_occurrence PRIMARY KEY (model_run_id, disease_occurrence_id)
);

GRANT SELECT, INSERT ON model_run_disease_occurrence TO ${application_username};

DROP SCHEMA auto CASCADE;

CREATE schema auto;

CREATE TABLE auto.makes (
    make_id int,
    make_name varchar,
    make_ref_name varchar,
    CONSTRAINT makes_pkey PRIMARY KEY (make_id),
    CONSTRAINT unq_makes UNIQUE (make_ref_name)
);

CREATE TABLE auto.models (
    make_id int,
    model_id varchar,
    model_ref_name varchar,
    model_name varchar,
    CONSTRAINT models_pkey PRIMARY KEY (make_id, model_id),
    CONSTRAINT fkey_model_makes FOREIGN KEY (make_id)
    REFERENCES auto.makes (make_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

CREATE TABLE auto.model_years (
    make_id int,
    model_id varchar,
    year_num int,
    CONSTRAINT model_years_pkey PRIMARY KEY (make_id, model_id, year_num),
    CONSTRAINT fkey_model_years_makes FOREIGN KEY (make_id)
    REFERENCES auto.makes (make_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

CREATE TABLE auto.vehicle_trims (
    trim_id int,
    make_id int,
    model_id varchar,
    trim_ref_name varchar,
    trim_name varchar
)

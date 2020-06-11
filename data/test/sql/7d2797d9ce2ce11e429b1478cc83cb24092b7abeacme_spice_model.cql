USE acme_space;

-------------------------------------
-- TABLE: acme_spice_model
-------------------------------------
DROP TABLE acme_spice_model;

CREATE TABLE acme_spice_model (
    model_id uuid PRIMARY KEY,
    tv_id uuid,
    model_name text,
    model_type text,
    model_desc text,
    model_file_path text,
    model_file_name text,
    file_id uuid,
    is_primary boolean,
    status text,
    update_time timestamp,
    update_user text,
    create_time timestamp,
    create_user text
) WITH COMPACT STORAGE;

-------------------------------------
-- INDEX
-------------------------------------
CREATE INDEX acme_spice_model_idx_tv_id ON acme_spice_model (tv_id);
CREATE INDEX acme_spice_model_idx_model_name ON acme_spice_model (model_name);
CREATE INDEX acme_spice_model_idx_model_type ON acme_spice_model (model_type);
CREATE INDEX acme_spice_model_idx_file_id ON acme_spice_model (file_id);
CREATE INDEX acme_spice_model_idx_is_primary ON acme_spice_model (is_primary);
CREATE INDEX acme_spice_model_idx_status ON acme_spice_model (status);
CREATE INDEX acme_spice_model_idx_update_time ON acme_spice_model (update_time);
CREATE INDEX acme_spice_model_idx_update_user ON acme_spice_model (update_user);
CREATE INDEX acme_spice_model_idx_create_time ON acme_spice_model (create_time);
CREATE INDEX acme_spice_model_idx_create_user ON acme_spice_model (create_user);
    

CREATE TABLE contact_list_element (
  id_flexible_element BIGINT
    PRIMARY KEY
    REFERENCES flexible_element(id_flexible_element),
  allowed_type VARCHAR,
  contact_limit INTEGER NOT NULL DEFAULT 0,
  is_member BOOLEAN NOT NULL DEFAULT false
);

CREATE TABLE contact_list_element_model (
  id_flexible_element INTEGER NOT NULL REFERENCES contact_list_element(id_flexible_element),
  id_contact_model INTEGER NOT NULL REFERENCES contact_model(id_contact_model),
  PRIMARY KEY (id_flexible_element, id_contact_model)
);

# Models Schema

# --- !Ups

CREATE SEQUENCE model_id_seq;
CREATE TABLE models (
    id integer NOT NULL DEFAULT nextval('model_id_seq'),
    modelNumber varchar(10) NOT NULL,
    companyID integer NOT NULL,
    FOREIGN KEY (companyID) REFERENCES manufacturers(id),
    PRIMARY KEY (id)
);

INSERT INTO models(modelNumber, companyID) VALUES ('6111', 1);
INSERT INTO models(modelNumber, companyID) VALUES ('420', 2);
INSERT INTO models(modelNumber, companyID) VALUES ('3958', 3);
INSERT INTO models(modelNumber, companyID) VALUES ('720', 4);
INSERT INTO models(modelNumber, companyID) VALUES ('712', 5);
INSERT INTO models(modelNumber, companyID) VALUES ('2005', 6);
INSERT INTO models(modelNumber, companyID) VALUES ('2005', 7);
INSERT INTO models(modelNumber, companyID) VALUES ('1320', 1);
INSERT INTO models(modelNumber, companyID) VALUES ('435', 1);
INSERT INTO models(modelNumber, companyID) VALUES ('738', 8);

# --- !Downs

DROP TABLE models;
DROP SEQUENCE model_id_seq;

CREATE TABLE eng_seq_type (
       id          SERIAL PRIMARY KEY,
       name        TEXT NOT NULL UNIQUE,
       description TEXT NOT NULL DEFAULT ''
);

INSERT INTO eng_seq_type ( name, description ) VALUES ( 'R1', 'R1 Gateway' );
INSERT INTO eng_seq_type ( name, description ) VALUES ( 'R2', 'R2 Gateway' );
INSERT INTO eng_seq_type ( name, description ) VALUES ( 'R3', 'R3 Gateway' );
INSERT INTO eng_seq_type ( name, description ) VALUES ( 'R4', 'R4 Gateway' );
INSERT INTO eng_seq_type ( name, description ) VALUES ( 'L1', 'L1 Gateway' );
INSERT INTO eng_seq_type ( name, description ) VALUES ( 'L2', 'L2 Gateway' );
INSERT INTO eng_seq_type ( name, description ) VALUES ( 'L3', 'L3 Gateway' );
INSERT INTO eng_seq_type ( name, description ) VALUES ( 'L4', 'L4 Gateway' );
INSERT INTO eng_seq_type ( name, description ) VALUES ( 'B1', 'B1 site' );
INSERT INTO eng_seq_type ( name, description ) VALUES ( 'B2', 'B2 site' );
INSERT INTO eng_seq_type ( name, description ) VALUES ( 'B3', 'B3 site' );
INSERT INTO eng_seq_type ( name, description ) VALUES ( 'B4', 'B4 site' );
INSERT INTO eng_seq_type ( name, description ) VALUES ( 'AB1', 'B1 append sequence' );
INSERT INTO eng_seq_type ( name, description ) VALUES ( 'AB2', 'B2 append sequence' );
INSERT INTO eng_seq_type ( name, description ) VALUES ( 'AB3', 'B3 append sequence' );
INSERT INTO eng_seq_type ( name, description ) VALUES ( 'AB4', 'B4 append sequence' );
INSERT INTO eng_seq_type ( name, description ) VALUES ( 'OAB1', 'Oligo B1 append sequence' );
INSERT INTO eng_seq_type ( name, description ) VALUES ( 'CAB1', 'Cassette B1 append sequence' );
INSERT INTO eng_seq_type ( name, description ) VALUES ( 'OAB2', 'Oligo B2 append sequence' );
INSERT INTO eng_seq_type ( name, description ) VALUES ( 'CAB2', 'Cassette B2 append sequence' );
INSERT INTO eng_seq_type ( name, description ) VALUES ( 'OAB3', 'Oligo B3 append sequence' );
INSERT INTO eng_seq_type ( name, description ) VALUES ( 'BAB3', 'Backbone B3 append sequence' );
INSERT INTO eng_seq_type ( name, description ) VALUES ( 'OAB4', 'Oligo B4 append sequence' );
INSERT INTO eng_seq_type ( name, description ) VALUES ( 'BAB4', 'Backbone B4 append sequence' );
INSERT INTO eng_seq_type ( name, description ) VALUES ( 'LoxP', 'LoxP sequence' );
INSERT INTO eng_seq_type ( name, description ) VALUES ( 'cassette', 'Cassette without gateway sites' );
INSERT INTO eng_seq_type ( name, description ) VALUES ( 'intermediate-cassette', 'Intermediate cassette' );
INSERT INTO eng_seq_type ( name, description ) VALUES ( 'final-cassette', 'Final cassette' );
INSERT INTO eng_seq_type ( name, description ) VALUES ( 'backbone', 'Backbone without gateway sites' );
INSERT INTO eng_seq_type ( name, description ) VALUES ( 'intermediate-backbone', 'Intermediate backbone' );
INSERT INTO eng_seq_type ( name, description ) VALUES ( 'final-backbone', 'Final backbone' );

CREATE TABLE eng_seq (
       id          SERIAL PRIMARY KEY,
       name        TEXT NOT NULL,
       class       TEXT NOT NULL CHECK ( class IN ( 'simple', 'compound' ) ),
       type_id     INTEGER NOT NULL REFERENCES eng_seq_type(id),
       description TEXT NOT NULL DEFAULT '',
       UNIQUE( name, type_id )
);


CREATE TABLE simple_eng_seq (
       id       INTEGER PRIMARY KEY REFERENCES eng_seq(id),
       seq      TEXT NOT NULL
);


CREATE TABLE compound_eng_seq_component (
       eng_seq_id       INTEGER NOT NULL REFERENCES eng_seq(id),
       rank             INTEGER NOT NULL,
       component_id     INTEGER NOT NULL REFERENCES eng_seq(id),
       PRIMARY KEY(eng_seq_id, rank)
);


CREATE TABLE eng_seq_feature (
       id                SERIAL PRIMARY KEY,
       eng_seq_id        INTEGER NOT NULL REFERENCES eng_seq(id),
       feature_start     INTEGER NOT NULL,
       feature_end       INTEGER NOT NULL,
       strand            INTEGER NOT NULL CHECK ( strand IN ( 1, -1, 0 ) ),
       source_tag        TEXT NOT NULL DEFAULT '',
       primary_tag       TEXT NOT NULL
);


CREATE INDEX eng_seq_feature_ix01 ON eng_seq_feature( eng_seq_id );

CREATE TABLE eng_seq_feature_tag (
       id                        SERIAL PRIMARY KEY,
       eng_seq_feature_id        INTEGER NOT NULL REFERENCES eng_seq_feature(id),
       name                      TEXT NOT NULL,
       UNIQUE (eng_seq_feature_id, name)
);


CREATE TABLE eng_seq_feature_tag_value (
       id                        SERIAL PRIMARY KEY,
       eng_seq_feature_tag_id    INTEGER NOT NULL REFERENCES eng_seq_feature_tag(id),
       value                     TEXT NOT NULL,
       UNIQUE (eng_seq_feature_tag_id, value)
);


-- CREATE TABLE eng_seq_annotation_class (
--        id                       SERIAL PRIMARY KEY,
--        name                     TEXT NOT NULL UNIQUE
-- );


-- INSERT INTO eng_seq_annotation_class ( name ) VALUES ( 'Bio::Annotation::Comment' );
-- INSERT INTO eng_seq_annotation_class ( name ) VALUES ( 'Bio::Annotation::DBLink' );
-- INSERT INTO eng_seq_annotation_class ( name ) VALUES ( 'Bio::Annotation::OntologyTerm' );
-- INSERT INTO eng_seq_annotation_class ( name ) VALUES ( 'Bio::Annotation::Reference' );
-- INSERT INTO eng_seq_annotation_class ( name ) VALUES ( 'Bio::Annotation::Relation' );
-- INSERT INTO eng_seq_annotation_class ( name ) VALUES ( 'Bio::Annotation::SimpleValue' );
-- INSERT INTO eng_seq_annotation_class ( name ) VALUES ( 'Bio::Annotation::StructuredValue' );
-- INSERT INTO eng_seq_annotation_class ( name ) VALUES ( 'Bio::Annotation::TagTree' );
-- INSERT INTO eng_seq_annotation_class ( name ) VALUES ( 'Bio::Annotation::Target' );
-- INSERT INTO eng_seq_annotation_class ( name ) VALUES ( 'Bio::Annotation::Tree' );

-- CREATE TABLE eng_seq_annotation (
--        id                       SERIAL PRIMARY KEY,
--        eng_seq_id               INTEGER NOT NULL REFERENCES eng_seq(id),
--        tagname                  TEXT NOT NULL,
--        class_id                 INTEGER NOT NULL REFERENCES eng_seq_annotation_class(id),
--        init_args                TEXT NOT NULL
-- );


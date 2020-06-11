CREATE TABLE RnaQuantification (
                       id TEXT NOT NULL PRIMARY KEY,
                       feature_set_ids TEXT,
                       description TEXT,
                       name TEXT,
                       read_group_ids TEXT,
                       programs TEXT,
                       biosample_id TEXT);
CREATE TABLE Expression (
                       id TEXT NOT NULL PRIMARY KEY,
                       rna_quantification_id TEXT,
                       name TEXT,
                       feature_id TEXT,
                       expression REAL,
                       is_normalized BOOLEAN,
                       raw_read_count REAL,
                       score REAL,
                       units INTEGER,
                       conf_low REAL,
                       conf_hi REAL);

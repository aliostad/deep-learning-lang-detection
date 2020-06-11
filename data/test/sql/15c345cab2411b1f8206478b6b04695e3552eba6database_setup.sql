drop schema public cascade;
create schema public;

CREATE TABLE IF NOT EXISTS reference_hash (
    mer     VARCHAR(20),
    location INTEGER[],
    PRIMARY KEY (mer)
);

CREATE INDEX mer_hash ON reference_hash USING hash (mer);

CREATE TABLE IF NOT EXISTS read (
    idx         INTEGER,
    left_read   CHAR(50),
    right_read  CHAR(50),
    PRIMARY KEY (idx)
);

CREATE TABLE IF NOT EXISTS read_raw (
    idx         INTEGER,
    left_read   CHAR(50),
    right_read  CHAR(50),
    PRIMARY KEY (idx)
);

-- This table is used to store the result after we do local alignment after hashing match
-- ref_idx = location in reference genome this is happening
-- mutation_type: 1 for delete, 2 for insert, 3 for SNP, 4 for match
-- insert_idx: start at 1, shows how far from the ref_idx this base is inserted in
-- new_base: of the SNP 
CREATE TABLE IF NOT EXISTS aligned_bases (
    id SERIAL,
    ref_idx         INTEGER,
    mutation_type   INTEGER,
    insert_idx      INTEGER,
    new_base        CHAR,
    read_idx        INTEGER
);

CREATE INDEX aligned_bases_ref_idx ON aligned_bases(ref_idx);


-- This table is used to store the result after we do local alignment after hashing match
-- ref_idx = same as aligned_bases
-- mutation_type: same as aligned_bases
-- insert_str: string that is inserted in here
-- new_base: of the SNP
CREATE TABLE IF NOT EXISTS mutation (
    id SERIAL,
    ref_idx         INTEGER,
    mutation_type   INTEGER,
    ins_str      VARCHAR(100),
    new_base        CHAR
);

CREATE TABLE IF NOT EXISTS unaligned_reads (
    read_idx        INTEGER
);

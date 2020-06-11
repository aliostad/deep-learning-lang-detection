INSERT INTO schema_versions(version) VALUES (114);

UPDATE design_oligo_appends 
    SET seq = 'GTGAGTGTGCTAGAGGGGGTG'
    WHERE id = 'artificial-intron' AND design_oligo_type_id = 'U5';

INSERT INTO design_append_aliases(design_type, alias)
    VALUES ('artificial-intron','artificial-intron'),
    ('intron-replacement','artificial-intron'),
    ('conditional','standard-ko'),
    ('deletion','standard-insdel'),
    ('insertion','standard-insdel'),
    ('gibson','gibson'),
    ('gibson-deletion','gibson'),
    ('fusion-deletion','fusion');

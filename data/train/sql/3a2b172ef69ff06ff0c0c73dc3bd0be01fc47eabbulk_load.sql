ALTER TABLE datamob_listings DISABLE KEYS;
LOAD DATA INFILE '/Users/doncarlo/data/datamob_dump/datamob_datasets-clean.tsv' 
   INTO TABLE datamob_listings
   FIELDS TERMINATED BY "\t" ENCLOSED BY '"'
   IGNORE 1 LINES
   (id, name, link, description, image_url, thumb_url, dmob_link)
;
ALTER TABLE datamob_listings ENABLE KEYS;

ALTER TABLE datamob_taggings DISABLE KEYS;
LOAD DATA INFILE '/Users/doncarlo/data/datamob_dump/datamob_datasets_taggings.tsv' 
   INTO TABLE datamob_taggings
   FIELDS TERMINATED BY "\t" ENCLOSED BY '"'
   IGNORE 1 LINES
   (dataset_id, tag_id)
;
ALTER TABLE datamob_taggings ENABLE KEYS;

ALTER TABLE datamob_tags DISABLE KEYS;
LOAD DATA INFILE '/Users/doncarlo/data/datamob_dump/datamob_datasets_tags.tsv' 
   INTO TABLE datamob_tags
   (id)
;
ALTER TABLE datamob_tags ENABLE KEYS;
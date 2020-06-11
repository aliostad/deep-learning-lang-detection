-- Name: am.size_mapping_new
-- Created: 2015-04-24 18:18:00
-- Updated: 2015-04-24 18:18:00

CREATE VIEW am.size_mapping_new AS
SELECT "csv_table".* FROM
(call "file".getFiles('am.size_mapping_new.csv')) f,
	TEXTTABLE(to_chars(f.file,'UTF-8') 
		COLUMNS 
		"commodity_group4" STRING ,
		"brand" STRING ,
		"eu_size" STRING ,
		"eu_length" STRING ,
		"Size Group Code" STRING ,
		"Description" STRING ,
		"NAV size" STRING ,
		"eu_size_x_length" STRING 
		DELIMITER ',' 
		QUOTE '''' 
		HEADER 1 
	)
"csv_table"



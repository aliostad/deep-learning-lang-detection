/*                                                                           *\
______________________________Patch Information________________________________

Description: Add Trigger for deleting files and move them to a backup table
Data Integrity: Safe

Required: Yes

\*                                                                           */

CREATE TRIGGER file_backup BEFORE DELETE on files
	FOR EACH ROW BEGIN
	
	INSERT INTO files_hidden 
	( id_file, quickhash, title, description, id_mimetype, datetime_added, datetime_deleted, filename, filesize ) 
	VALUES 
	( OLD.id_file, OLD.quickhash, OLD.title, OLD.description, OLD.id_mimetype, OLD.datetime_added, NOW(), OLD.filename, OLD.filesize );
END
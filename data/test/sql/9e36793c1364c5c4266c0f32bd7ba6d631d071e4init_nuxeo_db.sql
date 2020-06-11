--
-- recreate nuxeo database
--
DROP database IF EXISTS nuxeo;

-- All the rest of what is commented out below is now handled at startup
-- by the services web-app

-- CREATE database nuxeo DEFAULT CHARACTER SET utf8;


--
-- grant privileges to users on nuxeo database
--
-- GRANT ALL PRIVILEGES ON nuxeo.* TO '@DB_NUXEO_USER@'@'localhost' IDENTIFIED BY '@DB_NUXEO_PASSWORD@' WITH GRANT OPTION;
--
-- Grant privileges to read-only user on Nuxeo, for reporting. 
--
-- GRANT SELECT ON nuxeo.* TO 'reader'@'localhost' IDENTIFIED BY 'read';
--
-- Grant privileges to remote read-only users on Nuxeo, for reporting. 
-- These should be changed to reflect your domain. Avoid specifying
-- 'reader'@'%' (while simple and flexible, this is a potential security hole).
--
-- GRANT SELECT ON nuxeo.* TO 'reader'@'%.berkeley.edu' IDENTIFIED BY 'read';
-- GRANT SELECT ON nuxeo.* TO 'reader'@'%.movingimage.us' IDENTIFIED BY 'read';

FLUSH PRIVILEGES;


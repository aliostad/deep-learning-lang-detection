-- **********************************************************
-- *                                                        *
-- * IMPORTANT NOTE                                         *
-- *                                                        *
-- * This file has to be imported manually                  *
-- * The install tool will ignore it!                       *
-- *                                                        *
-- **********************************************************

UPDATE tl_dms_categories SET general_read_permission = "ALL" WHERE general_read_permission = "a";
UPDATE tl_dms_categories SET general_read_permission = "LOGGED_USER" WHERE general_read_permission = "r";
UPDATE tl_dms_categories SET general_read_permission = "CUSTOM" WHERE general_read_permission = "s";
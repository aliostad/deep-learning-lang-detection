-- ----------------------------------------------------------------------------
--  MySQL Table Creation
--
--  @author     Andrei I. Holub
--  @created    August 2, 2006
--  @version    $Id:$
-- ----------------------------------------------------------------------------

/* The link between the field category & modules */
CREATE TABLE module_field_categorylink (
  id INTEGER AUTO_INCREMENT NOT NULL PRIMARY KEY,
  module_id INTEGER NOT NULL REFERENCES permission_category(category_id),
  category_id INT UNIQUE NOT NULL,
  level INTEGER DEFAULT 0,
  description TEXT,
  entered TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  modified TIMESTAMP NULL
);

CREATE TRIGGER module_field_categorylink_entries BEFORE INSERT ON  module_field_categorylink FOR EACH ROW SET
NEW.entered = IF(NEW.entered IS NULL OR NEW.entered = '0000-00-00 00:00:00', NOW(), NEW.entered),
NEW.modified = IF (NEW.modified IS NULL OR NEW.modified = '0000-00-00 00:00:00', NEW.entered, NEW.modified);
 
/* Each module can have multiple categories or folders of custom data */
CREATE TABLE custom_field_category (
  module_id INTEGER NOT NULL REFERENCES module_field_categorylink(category_id),
  category_id INTEGER AUTO_INCREMENT NOT NULL PRIMARY KEY,
  category_name VARCHAR(255) NOT NULL,
  level INTEGER DEFAULT 0,
  description TEXT,
  start_date TIMESTAMP NULL,
  end_date TIMESTAMP NULL,
  default_item BOOLEAN DEFAULT false,
  entered TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  enabled BOOLEAN DEFAULT true,
  multiple_records BOOLEAN DEFAULT false,
  read_only BOOLEAN DEFAULT false,
  modified TIMESTAMP NULL
);

CREATE TRIGGER custom_field_category_entries BEFORE INSERT ON  custom_field_category FOR EACH ROW SET
NEW.entered = IF(NEW.entered IS NULL OR NEW.entered = '0000-00-00 00:00:00', NOW(), NEW.entered),
NEW.modified = IF (NEW.modified IS NULL OR NEW.modified = '0000-00-00 00:00:00', NEW.entered, NEW.modified),
NEW.start_date = IF (NEW.start_date IS NULL OR NEW.start_date = '0000-00-00 00:00:00', NEW.entered, NEW.start_date);

CREATE INDEX `custom_field_cat_idx` USING btree ON `custom_field_category` (`module_id`);

/* Each category can have multiple groups of fields */
CREATE TABLE custom_field_group (
  category_id INTEGER NOT NULL REFERENCES custom_field_category(category_id),
  group_id INTEGER AUTO_INCREMENT NOT NULL PRIMARY KEY,
  group_name VARCHAR(255) NOT NULL,
  level INTEGER DEFAULT 0,
  description TEXT,
  start_date TIMESTAMP NULL,
  end_date TIMESTAMP NULL,
  entered TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  enabled BOOLEAN DEFAULT true,
  modified TIMESTAMP NULL
);

CREATE TRIGGER custom_field_group_entries BEFORE INSERT ON  custom_field_group FOR EACH ROW SET
NEW.entered = IF(NEW.entered IS NULL OR NEW.entered = '0000-00-00 00:00:00', NOW(), NEW.entered),
NEW.modified = IF (NEW.modified IS NULL OR NEW.modified = '0000-00-00 00:00:00', NEW.entered, NEW.modified),
NEW.start_date = IF (NEW.start_date IS NULL OR NEW.start_date = '0000-00-00 00:00:00', NEW.entered, NEW.start_date);

CREATE INDEX `custom_field_grp_idx` USING btree ON `custom_field_group` (`category_id`);


/* Each folder has defined custom fields */
CREATE TABLE custom_field_info (
  group_id INTEGER NOT NULL REFERENCES custom_field_group(group_id),
  field_id INT AUTO_INCREMENT PRIMARY KEY,
  field_name VARCHAR(255) NOT NULL,
  level INTEGER DEFAULT 0,
  field_type INTEGER NOT NULL,
  validation_type INTEGER DEFAULT 0,
  required BOOLEAN DEFAULT false,
  parameters TEXT,
  start_date TIMESTAMP NULL,
  end_date TIMESTAMP NULL,
  entered TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  enabled BOOLEAN DEFAULT true,
  additional_text VARCHAR(255),
  modified TIMESTAMP NULL,
  default_value TEXT
);

CREATE TRIGGER custom_field_info_entries BEFORE INSERT ON  custom_field_info FOR EACH ROW SET
NEW.entered = IF(NEW.entered IS NULL OR NEW.entered = '0000-00-00 00:00:00', NOW(), NEW.entered),
NEW.modified = IF (NEW.modified IS NULL OR NEW.modified = '0000-00-00 00:00:00', NEW.entered, NEW.modified),
NEW.start_date = IF (NEW.start_date IS NULL OR NEW.start_date = '0000-00-00 00:00:00', NEW.entered, NEW.start_date);

CREATE INDEX `custom_field_inf_idx` USING btree ON `custom_field_info` (`group_id`);

/* List of values for type lookup table */
CREATE TABLE custom_field_lookup (
  field_id INTEGER NOT NULL REFERENCES custom_field_info(field_id),
  code INT AUTO_INCREMENT PRIMARY KEY,
  description VARCHAR(255) NOT NULL,
  default_item BOOLEAN DEFAULT false,
  level INTEGER DEFAULT 0,
  start_date TIMESTAMP NULL,
  end_date TIMESTAMP NULL,
  entered TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  enabled BOOLEAN DEFAULT true,
  modified TIMESTAMP NULL
);

CREATE TRIGGER custom_field_lookup_entries BEFORE INSERT ON  custom_field_lookup FOR EACH ROW SET
NEW.entered = IF(NEW.entered IS NULL OR NEW.entered = '0000-00-00 00:00:00', NOW(), NEW.entered),
NEW.modified = IF (NEW.modified IS NULL OR NEW.modified = '0000-00-00 00:00:00', NEW.entered, NEW.modified),
NEW.start_date = IF (NEW.start_date IS NULL OR NEW.start_date = '0000-00-00 00:00:00', NEW.entered, NEW.start_date);

/* The saved records in a folder associated with each category_id */
CREATE TABLE custom_field_record (
  link_module_id INTEGER NOT NULL,
  link_item_id INTEGER NOT NULL,
  category_id INTEGER NOT NULL REFERENCES custom_field_category(category_id),
  record_id INTEGER AUTO_INCREMENT NOT NULL PRIMARY KEY,
  entered TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  enteredby INT NOT NULL REFERENCES `access`(user_id),
  modified TIMESTAMP NULL,
  modifiedby INT NOT NULL REFERENCES `access`(user_id),
  enabled BOOLEAN DEFAULT true
);

CREATE TRIGGER custom_field_record_entries BEFORE INSERT ON  custom_field_record FOR EACH ROW SET
NEW.entered = IF(NEW.entered IS NULL OR NEW.entered = '0000-00-00 00:00:00', NOW(), NEW.entered),
NEW.modified = IF (NEW.modified IS NULL OR NEW.modified = '0000-00-00 00:00:00', NEW.entered, NEW.modified);

CREATE INDEX `custom_field_rec_idx` USING btree ON `custom_field_record` (`link_module_id`, `link_item_id`, `category_id`);

/* The saved custom field data related to a record_id (link_id) */
CREATE TABLE custom_field_data (
  record_id INTEGER NOT NULL REFERENCES custom_field_record(record_id),
  field_id INTEGER NOT NULL REFERENCES custom_field_info(field_id),
  selected_item_id INTEGER DEFAULT 0,
  entered_value TEXT,
  entered_number INTEGER,
  entered_float FLOAT,
  entered TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  modified TIMESTAMP NULL,
  data_id INTEGER AUTO_INCREMENT NOT NULL PRIMARY KEY
);

CREATE TRIGGER custom_field_data_entries BEFORE INSERT ON  custom_field_data FOR EACH ROW SET
NEW.entered = IF(NEW.entered IS NULL OR NEW.entered = '0000-00-00 00:00:00', NOW(), NEW.entered),
NEW.modified = IF (NEW.modified IS NULL OR NEW.modified = '0000-00-00 00:00:00', NEW.entered, NEW.modified);

CREATE INDEX `custom_field_dat_idx` USING btree ON `custom_field_data` (`record_id`, `field_id`);


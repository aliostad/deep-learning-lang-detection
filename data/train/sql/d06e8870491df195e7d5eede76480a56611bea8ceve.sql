attach database :memory as dump;

DROP TABLE IF EXISTS dump.invGroups;
CREATE TABLE dump.invGroups (
  "groupID" smallint(6) NOT NULL,
  "categoryID" tinyint(3) default NULL,
  "groupName" varchar(100) DEFAULT NULL,
  PRIMARY KEY  ("groupID")
);
DROP TABLE IF EXISTS dump.invTypes;
CREATE TABLE dump.invTypes (
  "typeID" int(11) NOT NULL,
  "groupID" smallint(6) default NULL,
  "typeName" varchar(100) default NULL,
  "radius" double default NULL,
  "mass" double default NULL,
  "volume" double default NULL,
  "capacity" double default NULL,
  "portionSize" int(11) default NULL,
  "raceID" tinyint(3) default NULL,
  "published" tinyint(1) default NULL,
  PRIMARY KEY  ("typeID")
);
DROP TABLE IF EXISTS dump.invCategories;
CREATE TABLE dump.invCategories (
"categoryID"  tinyint(3) NOT NULL,
"categoryName"  TEXT(100),
"iconID" smallint(6) default NULL,
"published"  tinyint(1),
PRIMARY KEY ("categoryID")
);

INSERT INTO dump.invGroups SELECT groupID, categoryID, groupName  FROM invGroups;
--INSERT INTO dump.invTypes SELECT typeID, groupID, typeName, radius, mass, volume, capacity, portionSize, raceID, published FROM invTypes;
INSERT INTO dump.invTypes SELECT typeID, groupID, typeName, 0, mass, volume, capacity, portionSize, raceID, published FROM invTypes;
INSERT INTO dump.invCategories SELECT * FROM invCategories;

CREATE INDEX dump.invGroups_categoryID ON "invGroups" ("categoryID" ASC);
CREATE INDEX dump.invTypes_groupID_published ON "invTypes" ("groupID" ASC, "published" ASC);
CREATE INDEX dump.invTypes_typeName ON "invTypes" ("typeName" ASC);

.backup dump dump.sqlite
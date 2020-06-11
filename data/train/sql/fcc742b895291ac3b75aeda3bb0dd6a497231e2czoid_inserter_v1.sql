/*
INSERT INTO model 
(name,description,manufacturer,scale,series,year_of_release,cover_price,cover_price_currency,selling_price,selling_price_currency,store,status)
VALUES
('',NULL,'','','',,,'',,'','','unboxed');

INSERT INTO zoid
(model_id,zoid_series,zoid_series_number,zoid_model_number)
VALUES
(LAST_INSERT_ID(),'',,'');

INSERT INTO model_has_category
(model_id,category_id)
VALUES
(LAST_INSERT_ID(),(SELECT @zoid_id));
*/

SET @zoid_id := (SELECT id FROM category WHERE name LIKE 'zoid');

INSERT INTO model 
(name,description,manufacturer,scale,series,year_of_release,cover_price,cover_price_currency,selling_price,selling_price_currency,store,status)
VALUES
('Geno Breaker Raven Ver.',NULL,'Kotobukiya','1/72','Zoids',2009,9200,'Japanese Yen',7360,'Japanese Yen','Hobby Link Japan','boxed');

INSERT INTO zoid
(model_id,zoid_series,zoid_series_number,zoid_model_number)
VALUES
(LAST_INSERT_ID(),'Highend Master Model',35,'EZ-034');

INSERT INTO model_has_category
(model_id,category_id)
VALUES
(LAST_INSERT_ID(),(SELECT @zoid_id));

INSERT INTO model 
(name,description,manufacturer,scale,series,year_of_release,cover_price,cover_price_currency,selling_price,selling_price_currency,store,status)
VALUES
('Gun Sniper Leena Special',NULL,'Kotobukiya','1/72','Zoids',2011,4500,'Japanese Yen',3600,'Japanese Yen','Hobby Link Japan','boxed');

INSERT INTO zoid
(model_id,zoid_series,zoid_series_number,zoid_model_number)
VALUES
(LAST_INSERT_ID(),'Highend Master Model',24,'RZ-030');

INSERT INTO model_has_category
(model_id,category_id)
VALUES
(LAST_INSERT_ID(),(SELECT @zoid_id));

INSERT INTO model 
(name,description,manufacturer,scale,series,year_of_release,cover_price,cover_price_currency,selling_price,selling_price_currency,store,status)
VALUES
('Berserk Fuhrer',NULL,'Kotobukiya','1/72','Zoids',2015,8800,'Japanese Yen',7040,'Japanese Yen','Hobby Link Japan','boxed');

INSERT INTO zoid
(model_id,zoid_series,zoid_series_number,zoid_model_number)
VALUES
(LAST_INSERT_ID(),'Highend Master Model',33,'EZ-049');

INSERT INTO model_has_category
(model_id,category_id)
VALUES
(LAST_INSERT_ID(),(SELECT @zoid_id));

INSERT INTO model 
(name,description,manufacturer,scale,series,year_of_release,cover_price,cover_price_currency,selling_price,selling_price_currency,store,status)
VALUES
('Dibison Toma Custom',NULL,'Kotobukiya','1/72','Zoids',2012,9800,'Japanese Yen',7840,'Japanese Yen','Hobby Link Japan','boxed');

INSERT INTO zoid
(model_id,zoid_series,zoid_series_number,zoid_model_number)
VALUES
(LAST_INSERT_ID(),'Highend Master Model',36,'RZ-031');

INSERT INTO model_has_category
(model_id,category_id)
VALUES
(LAST_INSERT_ID(),(SELECT @zoid_id));

INSERT INTO model 
(name,description,manufacturer,scale,series,year_of_release,cover_price,cover_price_currency,selling_price,selling_price_currency,store,status)
VALUES
('Shadow Fox',NULL,'Kotobukiya','1/72','Zoids',2012,4500,'Japanese Yen',3600,'Japanese Yen','Hobby Link Japan','unboxed');

INSERT INTO zoid
(model_id,zoid_series,zoid_series_number,zoid_model_number)
VALUES
(LAST_INSERT_ID(),'Highend Master Model',34,'RZ-046');

INSERT INTO model_has_category
(model_id,category_id)
VALUES
(LAST_INSERT_ID(),(SELECT @zoid_id));

INSERT INTO model 
(name,description,manufacturer,scale,series,year_of_release,cover_price,cover_price_currency,selling_price,selling_price_currency,store,status)
VALUES
('Dark Horn',NULL,'Kotobukiya','1/72','Zoids',2010,6800,'Japanese Yen',5440,'Japanese Yen','Hobby Link Japan','unboxed');

INSERT INTO zoid
(model_id,zoid_series,zoid_series_number,zoid_model_number)
VALUES
(LAST_INSERT_ID(),'Highend Master Model',21,'DPZ-10');

INSERT INTO model_has_category
(model_id,category_id)
VALUES
(LAST_INSERT_ID(),(SELECT @zoid_id));

INSERT INTO model 
(name,description,manufacturer,scale,series,year_of_release,cover_price,cover_price_currency,selling_price,selling_price_currency,store,status)
VALUES
('Command Wolf LC & AC Barad Ver.',NULL,'Kotobukiya','1/72','Zoids',2010,4800,'Japanese Yen',3840,'Japanese Yen','Hobby Link Japan','boxed');

INSERT INTO zoid
(model_id,zoid_series,zoid_series_number,zoid_model_number)
VALUES
(LAST_INSERT_ID(),'Highend Master Model',23,'RZ-042');

INSERT INTO model_has_category
(model_id,category_id)
VALUES
(LAST_INSERT_ID(),(SELECT @zoid_id));

INSERT INTO model 
(name,description,manufacturer,scale,series,year_of_release,cover_price,cover_price_currency,selling_price,selling_price_currency,store,status)
VALUES
('Lightning Saix',NULL,'Kotobukiya','1/72','Zoids',2010,4500,'Japanese Yen',3600,'Japanese Yen','Hobby Link Japan','unboxed');

INSERT INTO zoid
(model_id,zoid_series,zoid_series_number,zoid_model_number)
VALUES
(LAST_INSERT_ID(),'Highend Master Model',20,'EZ-035');

INSERT INTO model_has_category
(model_id,category_id)
VALUES
(LAST_INSERT_ID(),(SELECT @zoid_id));

INSERT INTO model 
(name,description,manufacturer,scale,series,year_of_release,cover_price,cover_price_currency,selling_price,selling_price_currency,store,status)
VALUES
('Iron Kong',NULL,'Three Zero','1/72','Zoids',2015,38000,'Japanese Yen',38000,'Japanese Yen','Hobby Link Japan','unboxed');

INSERT INTO zoid
(model_id,zoid_series,zoid_series_number,zoid_model_number)
VALUES
(LAST_INSERT_ID(),NULL,NULL,'EZ-015');

INSERT INTO model_has_category
(model_id,category_id)
VALUES
(LAST_INSERT_ID(),(SELECT @zoid_id));

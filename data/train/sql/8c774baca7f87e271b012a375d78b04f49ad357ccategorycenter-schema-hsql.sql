drop table value if exists ;
CREATE TABLE value (
  id int NOT NULL identity primary key,
  valueName varchar(45)
);

drop table property if exists ;
CREATE TABLE property (
  id int NOT NULL identity primary key,
  name varchar(45)
);

drop table productcategory if exists ;
CREATE TABLE productcategory (
  id int NOT NULL identity primary key,
  name varchar(45),
  description varchar(100),
  parentId int NOT NULL
);

drop table navigatecategory if exists ;
CREATE TABLE navigatecategory (
  id int NOT NULL identity primary key,
  name varchar(45),
  description varchar(100),
  keyWord varchar(100),
  conditions varchar(100),
  settings varchar(1000),
  priority int NOT NULL,
  parentId int NOT NULL
);

DROP table CategoryAssociation if exists ;
CREATE TABLE  CategoryAssociation (
  navId int NOT NULL,
  cid int NOT NULL
);

drop table categoryproperty if exists ;
CREATE TABLE categoryproperty (
  id int NOT NULL identity primary key,
  propertyType varchar(45),
  categoryId int NOT NULL,
  propertyId int NOT NULL,
  multiValue tinyint NOT NULL,
  compareable tinyint DEFAULT 0,
  priority int NOT NULL
);


drop table navcategoryproperty if exists ;
CREATE TABLE navcategoryproperty (
  id int NOT NULL identity primary key,
  navCategoryId int NOT NULL,
  propertyId int NOT NULL,
  priority int NOT NULL,
  searchable tinyint default 0
);


drop table categorypropertyvalue if exists ;
CREATE TABLE categorypropertyvalue (
  id int NOT NULL identity primary key,
  categoryId int NOT NULL,
  propertyId int NOT NULL,
  priority int NOT NULL,
  valueId int NOT NULL
);

drop table navcategorypropertyvalue if exists ;
CREATE TABLE navcategorypropertyvalue (
  id int NOT NULL identity primary key,
  navCategoryId int NOT NULL,
  propertyId int NOT NULL,
  priority int NOT NULL,
  valueId int NOT NULL
);

drop table propertyvaluedetail if exists ;
CREATE TABLE propertyvaluedetail (
  id int NOT NULL identity primary key,
  propertyId int NOT NULL,
  valueId int NOT NULL,
  pictureUrl varchar(100),
  description varchar(100)
);




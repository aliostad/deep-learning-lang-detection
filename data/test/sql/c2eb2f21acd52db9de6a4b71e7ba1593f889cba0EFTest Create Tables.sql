

CREATE TABLE Car
(
  Id INT NOT NULL IDENTITY(1,1),
  Mfg VARCHAR(50) NULL,
  Model VARCHAR(50) NULL,
  [Year] INT NULL
)

INSERT INTO Car (Mfg, Model, [Year]) VALUES ('Ford','Mustang', 1970);
INSERT INTO Car (Mfg, Model, [Year]) VALUES ('Ford','Mustang', 1998);
INSERT INTO Car (Mfg, Model, [Year]) VALUES ('Dodge','Viper', 2013);
INSERT INTO Car (Mfg, Model, [Year]) VALUES ('Toyota','Camry', 2005);
INSERT INTO Car (Mfg, Model, [Year]) VALUES ('Toyota','Prius', 2011);
INSERT INTO Car (Mfg, Model, [Year]) VALUES ('Porche','911 Turbo', 2004);

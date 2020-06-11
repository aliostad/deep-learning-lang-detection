CREATE DATABASE MonteCarlo;
GO;

CREATE TABLE modelType (
	strModel varchar(32) NOT NULL PRIMARY KEY,
)

CREATE TABLE modelYear (
	intYear int NOT NULL PRIMARY KEY,
)

CREATE TABLE intensities (
	intYear        int         NOT NULL,
	strModel       varchar(32) NOT NULL,
	intRun         int         NOT NULL,
	strCensa123Key varchar(3)  NOT NULL,
	fltIntensity   float           NULL,

	CONSTRAINT intensities_PK PRIMARY KEY (intRun, intYear, strModel, strCensa123Key),
	CONSTRAINT intensities_FK_modelYear FOREIGN KEY (intYear) REFERENCES ModelYear (intYear),
	CONSTRAINT intensities_FK_modelType FOREIGN KEY (strModel) REFERENCES modelType (strModel),
);

INSERT INTO modelType (strModel) VALUES('Single Region')
INSERT INTO modelType (strModel) VALUES('Two Region')

INSERT INTO modelYear (intYear) VALUES(2005)
INSERT INTO modelYear (intYear) VALUES(2006)
INSERT INTO modelYear (intYear) VALUES(2007)
INSERT INTO modelYear (intYear) VALUES(2008)
INSERT INTO modelYear (intYear) VALUES(2009)
INSERT INTO modelYear (intYear) VALUES(2010)

------------------------------------------------
--	START changing existing data structure
------------------------------------------------

DELETE FROM StrategyFinancial;
DELETE FROM StrategyModel;

ALTER TABLE Financial ADD
   StrategyGroupID int NULL; 

ALTER TABLE StrategyModel DROP 
  CONSTRAINT FK_StrategyModel_Model;
ALTER TABLE StrategyFinancial DROP 
  CONSTRAINT FK_StrategyFinancial_StrategyModel;

ALTER TABLE FinancialPool
  ALTER COLUMN Amount numeric(15,4) NULL;
ALTER TABLE StrategyFinancial
  ALTER COLUMN Amount numeric(15,4) NULL;

DROP TABLE StrategyModel;

--
--		StrategyGroup (parent to Strategy table AS 0..n)
--
CREATE TABLE StrategyGroup ( 
  StrategyGroupID	int 		NOT NULL,
  StrategyGroupTitle 	varchar(64)	NOT NULL
);

--
--		Strategy (parent to StrategyModel table AS 0..n)
--
CREATE TABLE Strategy ( 
  StrategyID		int IDENTITY (1,1) NOT NULL,
  StrategyTitle 	varchar(64)	NOT NULL,
  StrategyGroupID	int 		NOT NULL
);

--
--		StrategyModel::Model (Strategy extension to Model table AS 0..1)
--
CREATE TABLE StrategyModel ( 
  StrategyModelID		int IDENTITY (1,1) NOT NULL,
  StrategyModelTitle 		varchar(64)	NOT NULL,
  StrategyID			int 		NOT NULL,
  ModelTypeID 			int,
  ModelData 			text
);


------------------------------------------------
--	END changing existing data structure
------------------------------------------------




--
--				PRIMARY KEY
--
ALTER TABLE StrategyGroup ADD CONSTRAINT PK_StrategyGroup PRIMARY KEY (StrategyGroupID);
ALTER TABLE Strategy ADD CONSTRAINT PK_Strategy PRIMARY KEY (StrategyID);
ALTER TABLE StrategyModel ADD CONSTRAINT PK_StrategyModel PRIMARY KEY (StrategyModelID);


--
--				FOREIGN KEY
--
ALTER TABLE Financial ADD
  CONSTRAINT FK_Financial_StrategyGroup FOREIGN KEY (StrategyGroupID) REFERENCES StrategyGroup (StrategyGroupID);

ALTER TABLE StrategyGroup ADD
  CONSTRAINT FK_StrategyGroup_Object FOREIGN KEY (StrategyGroupID) REFERENCES Object (ObjectID);

ALTER TABLE Strategy ADD
  CONSTRAINT FK_Strategy_StrategyGroup FOREIGN KEY (StrategyGroupID) REFERENCES StrategyGroup (StrategyGroupID);

ALTER TABLE StrategyModel ADD
  CONSTRAINT FK_StrategyModel_Strategy FOREIGN KEY (StrategyID) REFERENCES Strategy (StrategyID),
  CONSTRAINT FK_StrategyModel_ModelType FOREIGN KEY (ModelTypeID) REFERENCES ModelType (ModelTypeID);

ALTER TABLE StrategyFinancial ADD
  CONSTRAINT FK_StrategyFinancial_StrategyModel FOREIGN KEY (StrategyModelID) REFERENCES StrategyModel (StrategyModelID);

--
--				UNIQUE INDEX
--



--
--				INDEX
--


--
--				INSERT/UPDATE
--
INSERT INTO ObjectType (ObjectTypeID, ObjectTypeDesc)
VALUES (32, 'StrategyGroup table');

INSERT INTO ObjectType (ObjectTypeID, ObjectTypeDesc)
VALUES (1032, 'Link table (Person to StrategyGroup)');
INSERT INTO LinkObjectType (LinkObjectTypeID, ObjectTypeID1, ObjectTypeID2, LinkObjectTypeDesc)
VALUES (1032, 1, 32, 'Link Person to StrategyGroup');


--
-- this should be the last statement in any update script
--
INSERT INTO DBVersion (CurrentVersion, PreviousVersion)
VALUES ('FID.01.15', 'FID.01.14');


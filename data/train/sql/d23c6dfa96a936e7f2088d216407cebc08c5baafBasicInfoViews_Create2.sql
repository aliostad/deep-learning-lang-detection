CREATE VIEW [BasicInfo].[ActivityLocationView] AS SELECT * FROM BasicInfo.ActivityLocation;


CREATE VIEW [BasicInfo].[CompanyGoodUnitView] AS SELECT * FROM BasicInfo.CompanyGoodUnit;


CREATE VIEW [BasicInfo].[CompanyView] AS SELECT * FROM BasicInfo.Company;


CREATE VIEW [BasicInfo].[CurrencyView] AS SELECT * FROM BasicInfo.Currency ;

CREATE VIEW [BasicInfo].[GoodPartyAssignmentView] AS SELECT * FROM BasicInfo.GoodPartyAssignment;

CREATE VIEW [BasicInfo].[GoodView] AS SELECT * FROM BasicInfo.Good ;

CREATE VIEW [BasicInfo].[SharedGoodView] AS SELECT   Id, Name, Code, MainUnitId FROM BasicInfo.SharedGood;


CREATE VIEW [BasicInfo].[TankView] AS SELECT * FROM BasicInfo.Tank ;


CREATE VIEW [BasicInfo].[UnitView] AS SELECT * FROM BasicInfo.Unit ;

CREATE VIEW [BasicInfo].[UserView] AS SELECT * FROM BasicInfo.[User]; 


CREATE VIEW [BasicInfo].[VesselView] AS SELECT * FROM BasicInfo.Vessel ;

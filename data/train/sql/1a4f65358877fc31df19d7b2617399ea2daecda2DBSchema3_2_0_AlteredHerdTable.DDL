
-- Drop foreign key constraints from table `outIterationByHerd`.
alter table `outIterationByHerd`
	drop constraint `readApparentStateCodes_outIterationByHerd_FK1`;


-- Drop foreign key constraints from table `dynHerd`.
alter table `dynHerd`
	drop constraint `readApparentStateCodes_dynHerd_FK1`;


-- Drop primary key, unique and non-unique index constraints from table `readApparentStateCodes`.
alter table `readApparentStateCodes` drop constraint `readApparentStateCodes_PK`; 


-- Update existing table `outIterationByHerd`.
create table `outIterationByHerd_IM0` ( 
	`iteration` INTEGER,
	`herdID` INTEGER,
	`lastStatusCode` CHAR(1),
	`lastStatusDay` INTEGER,
	`lastApparentStateCode` CHAR(1),
	`lastApparentStateDay` INTEGER); 

insert into `outIterationByHerd_IM0` (`iteration`, `herdID`, `lastStatusCode`, `lastStatusDay`, `lastApparentStateCode`, `lastApparentStateDay`) 
    select `outIterationByHerd`.`iteration`, 
           `outIterationByHerd`.`herdID`, 
           `outIterationByHerd`.`lastStatusCode`, 
           `outIterationByHerd`.`lastStatusDay`, 
           `outIterationByHerd`.`lastApparentStateCode`, 
           `outIterationByHerd`.`lastApparentStateDay`  
    from `outIterationByHerd`;


alter table `outIterationByHerd`
	drop constraint `dynHerd_outIterationByHerd_FK1`;


alter table `outIterationByHerd`
	drop constraint `readStatusCodes_outIterationByHerd_FK1`;


drop table `outIterationByHerd`; 


create table `outIterationByHerd` ( 
	`iteration` INTEGER,
	`herdID` INTEGER,
	`lastStatusCode` CHAR(1),
	`lastStatusDay` INTEGER,
	`lastControlStateCode` CHAR(1),
	`lastControlStateDay` INTEGER); 

insert into `outIterationByHerd` (`iteration`, `herdID`, `lastStatusCode`, `lastStatusDay`, `lastControlStateCode`, `lastControlStateDay`) 
    select `outIterationByHerd_IM0`.`iteration`, 
           `outIterationByHerd_IM0`.`herdID`, 
           `outIterationByHerd_IM0`.`lastStatusCode`, 
           `outIterationByHerd_IM0`.`lastStatusDay`, 
           `outIterationByHerd_IM0`.`lastApparentStateCode`, 
           `outIterationByHerd_IM0`.`lastApparentStateDay`  
    from `outIterationByHerd_IM0`;


drop table `outIterationByHerd_IM0`; 


alter table `outIterationByHerd`
	add constraint `outIterationByHerd_PK` primary key (`herdID`, `iteration`) ; 


-- Create new table `readDetectionStateCodes`.
create table `readDetectionStateCodes` ( 
	`detectionStateCode` CHAR(1),
	`definition` VARCHAR(255), constraint `readDetectionStateCodes_PK` primary key (`detectionStateCode`) ); 


-- Update existing table `dynHerd`.
create table `dynHerd_IM0` ( 
	`herdID` COUNTER,
	`productionTypeID` INTEGER,
	`latitude` DOUBLE,
	`longitude` DOUBLE,
	`initialStateCode` CHAR(1),
	`daysInInitialState` INTEGER,
	`daysLeftInInitialState` INTEGER,
	`initialSize` INTEGER,
	`finalStateCode` CHAR(1),
	`finalApparentStateCode` CHAR(1),
	`cumInfected` INTEGER,
	`cumDetected` INTEGER,
	`cumDestroyed` INTEGER,
	`cumVaccinated` INTEGER); 

insert into `dynHerd_IM0` ( `herdID`, `productionTypeID`, `latitude`, `longitude`, `daysInInitialState`, `initialStateCode`, `daysLeftInInitialState`, `initialSize`, `finalStateCode`, `finalApparentStateCode`, `cumInfected`, `cumDetected`, `cumDestroyed`, `cumVaccinated`) 
    select `dynHerd`.`herdID`, 
           `dynHerd`.`productionTypeID`, 
           `dynHerd`.`latitude`, 
           `dynHerd`.`longitude`, 
           `dynHerd`.`daysInInitialState`, 
           `dynHerd`.`initialStateCode`, 
           `dynHerd`.`daysLeftInInitialState`, 
           `dynHerd`.`initialSize`, 
           `dynHerd`.`finalStateCode`, 
           `dynHerd`.`finalApparentStateCode`, 
           `dynHerd`.`cumInfected`, 
           `dynHerd`.`cumDetected`, 
           `dynHerd`.`cumDestroyed`, 
           `dynHerd`.`cumVaccinated`  
    from `dynHerd`;


alter table `outDailyExposures`
	drop constraint `dynHerd_outDailyExposures_FK1`;


alter table `outDailyExposures`
	drop constraint `dynHerd_outDailyExposures_FK2`;


alter table `outDailyEvents`
	drop constraint `dynHerd_outDailyEvents_FK1`;


alter table `dynHerd`
	drop constraint `inProductionType_dynHerd_FK1`;


alter table `dynHerd`
	drop constraint `readStatusCodes_dynHerd_FK1`;


alter table `dynHerd`
	drop constraint `readStatusCodes_dynHerd_FK2`;


drop table `dynHerd`; 


create table `dynHerd` ( 
	`herdID` COUNTER,
	`productionTypeID` INTEGER,
	`latitude` DOUBLE,
	`longitude` DOUBLE,
	`initialStateCode` CHAR(1),
	`daysInInitialState` INTEGER,
	`daysLeftInInitialState` INTEGER,
	`initialSize` INTEGER,
	`finalStateCode` CHAR(1),
	`finalControlStateCode` CHAR(1),
	`finalDetectionStateCode` CHAR(1),
	`cumulInfected` INTEGER,
	`cumulDetected` INTEGER,
	`cumulDestroyed` INTEGER,
	`cumulVaccinated` INTEGER); 


insert into `dynHerd` ( `herdID`, `productionTypeID`, `latitude`, `longitude`, `daysInInitialState`, `initialStateCode`, `daysLeftInInitialState`, `initialSize`, `finalStateCode`, `finalControlStateCode`, `cumulInfected`, `cumulDetected`, `cumulDestroyed`, `cumulVaccinated`) 
    select `dynHerd_IM0`.`herdID`,
           `dynHerd_IM0`.`productionTypeID`, 
           `dynHerd_IM0`.`latitude`, 
           `dynHerd_IM0`.`longitude`, 
           `dynHerd_IM0`.`daysInInitialState`, 
           `dynHerd_IM0`.`initialStateCode`, 
           `dynHerd_IM0`.`daysLeftInInitialState`, 
           `dynHerd_IM0`.`initialSize`, 
           `dynHerd_IM0`.`finalStateCode`, 
           `dynHerd_IM0`.`finalApparentStateCode`, 
           `dynHerd_IM0`.`cumInfected`, 
           `dynHerd_IM0`.`cumDetected`, 
           `dynHerd_IM0`.`cumDestroyed`, 
           `dynHerd_IM0`.`cumVaccinated`  
    from `dynHerd_IM0`;


drop table `dynHerd_IM0`; 


alter table `dynHerd`
	add constraint `dynHerd_PK` primary key (`herdID`) ; 


-- Rename table from readApparentStateCodes to readControlStateCodes.
create table `readControlStateCodes` ( 
	`controlStateCode` CHAR(1),
	`definition` VARCHAR(255)); 

insert into `readControlStateCodes` (`controlStateCode`, `definition`) 
    select `readApparentStateCodes`.`apparentStateCode`, 
           `readApparentStateCodes`.`definition`  
    from `readApparentStateCodes`;


drop table `readApparentStateCodes`; 


-- Restore foreign key constraints for existing tables
alter table `outIterationByHerd`
	add constraint `dynHerd_outIterationByHerd_FK1` foreign key (
		`herdID`)
	 references `dynHerd` (
		`herdID`); 

alter table `outIterationByHerd`
	add constraint `readStatusCodes_outIterationByHerd_FK1` foreign key (
		`lastStatusCode`)
	 references `readStatusCodes` (
		`statusCode`); 

alter table `dynHerd`
	add constraint `inProductionType_dynHerd_FK1` foreign key (
		`productionTypeID`)
	 references `inProductionType` (
		`productionTypeID`); 

alter table `dynHerd`
	add constraint `readStatusCodes_dynHerd_FK1` foreign key (
		`initialStateCode`)
	 references `readStatusCodes` (
		`statusCode`); 

alter table `dynHerd`
	add constraint `readStatusCodes_dynHerd_FK2` foreign key (
		`finalStateCode`)
	 references `readStatusCodes` (
		`statusCode`); 

alter table `dynHerd`
	add constraint `readDetectionStateCodes_dynHerd_FK1` foreign key (
		`finalDetectionStateCode`)
	 references `readDetectionStateCodes` (
		`detectionStateCode`); 

alter table `outDailyExposures`
	add constraint `dynHerd_outDailyExposures_FK1` foreign key (
		`exposedHerdID`)
	 references `dynHerd` (
		`herdID`); 

alter table `outDailyExposures`
	add constraint `dynHerd_outDailyExposures_FK2` foreign key (
		`exposingHerdID`)
	 references `dynHerd` (
		`herdID`); 

alter table `outDailyEvents`
	add constraint `dynHerd_outDailyEvents_FK1` foreign key (
		`herdID`)
	 references `dynHerd` (
		`herdID`); 

-- Add the remaining keys, constraints and indexes for the table `readControlStateCodes`.
alter table `readControlStateCodes`
	add constraint `readApparentStateCodes_PK` primary key (`controlStateCode`) ; 


-- Add foreign key constraints to table `dynHerd`.
alter table `dynHerd`
	add constraint `readApparentStateCodes_dynHerd_FK1` foreign key (
		`finalControlStateCode`)
	 references `readControlStateCodes` (
		`controlStateCode`); 

-- Add foreign key constraints to table `outIterationByHerd`.
alter table `outIterationByHerd`
	add constraint `readApparentStateCodes_outIterationByHerd_FK1` foreign key (
		`lastControlStateCode`)
	 references `readControlStateCodes` (
		`controlStateCode`); 

-- This is the end of the Microsoft Visual Studio generated SQL DDL script.

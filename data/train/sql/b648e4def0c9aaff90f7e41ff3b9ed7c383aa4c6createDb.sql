CREATE DATABASE AirNav;

USE AirNav;

CREATE TABLE NavAid(
	NavAidID varchar(10) PRIMARY KEY, 
	NavAidName varchar(50),
	NavAidLocation point NOT NULL,
	NavAidStation varchar(50),
	NavAidFrequency float,
	SPATIAL INDEX(NavAidLocation)
) ENGINE=MyISAM;

CREATE TABLE RestrictedSpace(
	RSpaceId varchar(10) PRIMARY KEY,
	RSpaceName varchar(50),
	RSpace polygon NOT NULL,
	SPATIAL INDEX(RSpace)
) ENGINE=MyISAM;

CREATE TABLE Flights(
	CallSign varchar(10) PRIMARY KEY,
	AircraftType varchar(20),
	AircraftTrack lineString NOT NULL,
	SPATIAL INDEX(AircraftTrack)
) ENGINE=MyISAM;
---------------------------------------------------------------------------------------
-- In this block we're going to:
--   1) Add the FeatureUsage table
---------------------------------------------------------------------------------------

create schema TrialBalanceReporting
go

create table TrialBalanceReporting.FeatureUsageRecords (
	FeatureUsageRecordId uniqueidentifier not null constraint [PK_FeatureUsageRecords] primary key clustered,
	ApplicationName varchar(50) not null,
	ApplicationVersion varchar(50) not null,
	FeatureGroup varchar(300) not null,
	FeatureName varchar(300) not null,
	FeatureDetails varchar(300) not null,
	OperatingSystem varchar(70) not null,
	ClientIPAddress varchar(30) not null,
	DateRecorded datetime not null
)
go

create procedure TrialBalanceReporting.AppendFeatureUsageRecord (
	@applicationName varchar(50) not null,
	@applicationVersion varchar(50) not null,
	@featureGroup varchar(300) not null,
	@featureName varchar(300) not null,
	@featureDetails varchar(300) not null,
	@operatingSystem varchar(70) not null,
	@clientIPAddress varchar(30) not null,
	@dateRecorded datetime not null
)
as 
begin
	insert into TrialBalanceReporting.FeatureUsageRecords
		(FeatureUsageRecordId, ApplicationName, ApplicationVersion, FeatureGroup, FeatureName, FeatureDetails, OperatingSystem, ClientIPAddress, DateRecorded)
	values (
		@applicationName
		@applicationVersion
		@featureGroup
		@featureName
		@featureDetails
		@operatingSystem
		@clientIPAddress
		@dateRecorded
	);
end
go
		
		

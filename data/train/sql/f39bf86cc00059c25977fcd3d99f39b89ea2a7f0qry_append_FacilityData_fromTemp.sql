CREATE PROCEDURE [dbo].[qry_append_FacilityData_fromTemp]
AS
INSERT INTO FacilityData ( FacilityIndex, [IndicatorSerial], ReferenceYear, ReferenceMonth, GenderId, AgeGroupId, [IndicatorValue] )
SELECT FacilityIndex, IndicatorCode, YearID, ReferenceMonth, Sex, AgeGroupId, Value
FROM qryCopyFromTempToMain
WHERE 
(	
		(
			convert(varchar,[FacilityIndex]) +
			convert(varchar,[YearID]) +
			convert(varchar,[ReferenceMonth]) 
		) 
		Not In 
		( select convert(varchar,[FacilityIndex]) + convert(varchar,ReferenceYear) + convert(varchar,ReferenceMonth) as FacilityYearMonth from FacilityData )	
);
RETURN 0
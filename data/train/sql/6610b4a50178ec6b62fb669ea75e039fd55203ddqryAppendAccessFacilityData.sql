CREATE PROCEDURE [dbo].[qryAppendAccessFacilityData]
AS
	INSERT INTO FacilityData ( FacilityIndex, [IndicatorSerial], ReferenceYear, ReferenceMonth, GenderId, AgeGroupId, IndicatorValue )
SELECT accessFacilityDataTemp.FacilityIndex, accessFacilityDataTemp.Indicator, accessFacilityDataTemp.ReferenceYear, accessFacilityDataTemp.ReferenceMonth, accessFacilityDataTemp.Sex, accessFacilityDataTemp.AgeGroup, accessFacilityDataTemp.Number
FROM accessFacilityDataTemp LEFT JOIN FacilityData ON (accessFacilityDataTemp.AgeGroup = FacilityData.AgeGroupId) AND (accessFacilityDataTemp.Sex = FacilityData.GenderId) AND (accessFacilityDataTemp.ReferenceMonth = FacilityData.ReferenceMonth) AND (accessFacilityDataTemp.ReferenceYear = FacilityData.ReferenceYear) AND
 (accessFacilityDataTemp.Indicator = FacilityData.IndicatorSerial) AND (accessFacilityDataTemp.FacilityIndex = FacilityData.FacilityIndex)
WHERE (((FacilityData.FacilityIndex) Is Null));

RETURN 0

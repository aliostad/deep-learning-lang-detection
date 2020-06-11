USE [Lenawee]
GO 

--UPDATE dbo.NewTrainingData 
--SET car_value = v.NewCarValue, 
--	risk_factor = v.NewRiskFactor,
--	C_previous = v.NewCPrevious,
--	duration_previous = v.NewDurationPrev
--fROM dbo.NewTrainingData nd
--JOIN dbo.TrainingDataMissingValues v
--	ON v.CustomerID = nd.Customer_id
	

SELECT 'Original Missing Car Values'AS'Variable', COUNT(*)'Total'
FROM dbo.TrainingData
WHERE car_value IS NULL 
	UNION 
SELECT 'New Missing Car Values', COUNT(*) 
FROM dbo.NewTrainingData
WHERE car_value IS NULL 
	UNION
SELECT 'Original Missing Risk Factors', COUNT(*) 
FROM dbo.TrainingData
WHERE risk_factor IS NULL 
	UNION 
SELECT 'New Missing Risk Factors', COUNT(*) 
FROM dbo.NewTrainingData
WHERE risk_factor IS NULL 
	UNION 
SELECT 'Original Missing Previous Coverage', COUNT(*) 
FROM dbo.TrainingData
WHERE C_previous IS NULL 
	UNION 
SELECT 'New Missing Previous Coverage', COUNT(*) 
FROM dbo.NewTrainingData
WHERE C_previous IS NULL 
	UNION 
SELECT 'Original Missing Duration', COUNT(*) 
FROM dbo.TrainingData
WHERE duration_previous IS NULL 
	UNION 
SELECT 'New Missing Duration', COUNT(*) 
FROM dbo.NewTrainingData
WHERE duration_previous IS NULL 


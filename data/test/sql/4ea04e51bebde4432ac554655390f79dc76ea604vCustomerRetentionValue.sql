CREATE VIEW [Views].[vCustomerRetentionValue]
AS
WITH   customerValue AS (SELECT DimCustomer.CustomerCode,
                                DimCustomer.PartyName,
                                DimCustomer.ResidentialState,
                                FactCustomerValue.ValueRating,
                                ROW_NUMBER() OVER (PARTITION BY DimCustomer.CustomerCode ORDER BY FactCustomerValue.ValuationDateId DESC) AS recency
                         FROM   DW_Dimensional.DW.DimCustomer
                         INNER  JOIN DW_Dimensional.DW.FactCustomerValue ON FactCustomerValue.CustomerId = DimCustomer.CustomerId)
SELECT customerValue.CustomerCode,
       customerValue.ValueRating AS Rating,
       customerValue.PartyName AS PartyName,
       customerValue.ResidentialState AS ResidentialState
FROM   customerValue
WHERE  customerValue.recency = 1

GO


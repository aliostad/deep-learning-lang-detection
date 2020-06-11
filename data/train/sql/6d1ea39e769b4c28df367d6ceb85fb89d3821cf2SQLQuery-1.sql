SELECT     Customer.LastName, Customer.FirstName, COUNT(dbo.CustomerJob.PropertyID)
FROM         Customer INNER JOIN
                      Property ON Customer.CustomerID = Property.CustomerID INNER JOIN
                      Service ON Property.PropertyID = Service.PropertyID RIGHT OUTER JOIN
                      CustomerJob ON Property.PropertyID = CustomerJob.PropertyID 
WHERE     (Service.FourStepType = 1) and (CustomerJob.FourStepJob = 1)
GROUP BY dbo.Property.PropertyID, dbo.Customer.LastName, dbo.Customer.FirstName
ORDER BY Customer.LastName
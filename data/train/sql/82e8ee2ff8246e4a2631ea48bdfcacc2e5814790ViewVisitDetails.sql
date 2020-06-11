CREATE VIEW [dbo].[ViewVisitDetails]
AS
SELECT     *
FROM         (SELECT     dbo.ViewVisits.VisitId, dbo.ViewVisits.VisitNo, Person.PersonLanguages.DisplayName, dbo.ViewVisits.CustomerId, dbo.Customers.CompanyName, 
                                              dbo.ViewVisits.Finalized, dbo.ViewVisits.StartDateTime, dbo.ViewVisits.EndDateTime, dbo.ViewVisits.Accomplishment, dbo.ViewVisits.PendingTasks, 
                                              dbo.ViewVisits.VisitComments, dbo.ViewVisits.SupplierId, dbo.Suppliers.SupplierName, dbo.ViewVisits.ReferencedShotecNumbers, 
                                              dbo.ViewVisits.ReportDate, dbo.ViewVisits.CustomerNotes, dbo.ViewVisits.EngineerNotes, dbo.ViewVisits.Satisfied, dbo.ViewVisits.Reason, 
                                              dbo.ViewVisits.BranchID , dbo.ViewVisits.BranchNameFL , dbo.ViewVisits.BranchNameSL , dbo.ViewVisits.CountryID , dbo.ViewVisits.CountryName ,
                                              dbo.ViewVisits.Place, dbo.Customers.CompanyCode, dbo.ViewVisits.DetailsReason, Row_Number() OVER (PARTITION BY dbo.ViewVisits.VisitId
                        ORDER BY dbo.ViewVisits.VisitId) AS row
FROM         dbo.Suppliers RIGHT OUTER JOIN
                      dbo.Customers RIGHT OUTER JOIN
                      dbo.ViewVisits INNER JOIN
                      dbo.VisitEngineers INNER JOIN
                      Person.PersonLanguages ON dbo.VisitEngineers.ResponsibleEngineerID = Person.PersonLanguages.PersonId ON 
                      dbo.ViewVisits.VisitId = dbo.VisitEngineers.VisitID ON dbo.Customers.CustomerID = dbo.ViewVisits.CustomerId ON 
                      dbo.Suppliers.SupplierID = dbo.ViewVisits.SupplierId
WHERE     Person.PersonLanguages.LanguageId = 1) AS t
WHERE     t .row = 1

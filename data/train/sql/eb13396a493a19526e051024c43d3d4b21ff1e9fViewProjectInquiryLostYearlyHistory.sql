CREATE VIEW [dbo].[ViewProjectInquiryLostYearlyHistory]
AS
SELECT     *
FROM         (SELECT     ViewProjectInquiryYearlyHistory.ProjectSerialNumber, ViewProjectInquiryYearlyHistory.ShotecNo, ViewProjectInquiryYearlyHistory.ResponsibleEngineer, 
                                              ViewProjectInquiryYearlyHistory.ProjectID, ViewProjectInquiryYearlyHistory.ClientName, ViewProjectInquiryYearlyHistory.CompanyCode, 
                                              ViewProjectInquiryYearlyHistory.ClientWebsite, ViewProjectInquiryYearlyHistory.ClientInquiryNumber, ViewProjectInquiryYearlyHistory.InquiryDate, 
                                              ViewProjectInquiryYearlyHistory.ProjectStatus, ViewProjectInquiryYearlyHistory.InquiryTypeID, ViewProjectInquiryYearlyHistory.SupplierName, 
                                              ViewProjectInquiryYearlyHistory.SupplierQuotationNumber, ViewProjectInquiryYearlyHistory.QuotationPrice, 
                                              ViewProjectInquiryYearlyHistory.QuotationCurrency, ViewProjectInquiryYearlyHistory.QuotationRateToEURO, 
                                              ViewProjectInquiryYearlyHistory.QuotationRateDate, ViewProjectInquiryYearlyHistory.QuotationPriceInEuro, ViewProjectInquiryYearlyHistory.BidDueDate, 
                                              ViewProjectInquiryYearlyHistory.OnHold, ViewProjectInquiryYearlyHistory.ModifiedDate, ViewProjectInquiryYearlyHistory.UserName, 
                                              ViewProjectInquiryYearlyHistory.ProjectName, ViewProjectInquiryYearlyHistory.ProjectLocation, ViewProjectInquiryYearlyHistory.ProjectOwnerName, 
                                              ViewProjectInquiryYearlyHistory.ProjectDescription, ViewProjectInquiryYearlyHistory.ProductName, ViewProjectInquiryYearlyHistory.CategoryName, 
                                              ViewProjectInquiryYearlyHistory.ProductDescription, ViewProjectInquiryYearlyHistory.ProjectComment, LostReasons.ReasonName, 
                                              LostReasons.ReasonCode, LostsYearlyHistory.LostReasonID, LostsYearlyHistory.WinnerName AS LostWinnerName, 
                                              LostsYearlyHistory.WinnerPrice AS LostWinnerPrice, ViewProjectInquiryYearlyHistory.ResponsibleEngineerDisplayName, 
                                              ViewProjectInquiryYearlyHistory.LanguageId, LostsYearlyHistory.WinnerPriceInEuro AS LostWinnerPriceInEuro, 
                                              LostsYearlyHistory.RateToEuro AS LostWinnerRateToEuro, LostsYearlyHistory.RateDate AS LostWinnerRateDate, 
                                              LostsYearlyHistory.WinnerPriceCurrencyID AS LostWinnerPriceCurrencyID, ViewProjectInquiryYearlyHistory.InquiryStatus, 
                                              ViewProjectInquiryYearlyHistory.OrderPercentage, ViewProjectInquiryYearlyHistory.SupplierID, LostsYearlyHistory.ModifiedDate AS LostDate, 
                                              ViewProjectInquiryYearlyHistory.ProjectTypeID, ViewProjectInquiryYearlyHistory.OfferDate, ViewProjectInquiryYearlyHistory.ParentInquiryNumber, 
                                              ViewProjectInquiryYearlyHistory.IsSubOffer, LostsYearlyHistory.IsSubLost, LostsYearlyHistory.ParentInquiryNumber AS LostParentInquiryNumber, 
                                              ViewProjectInquiryYearlyHistory.CustomerID, LostsYearlyHistory.LostComment, ViewProjectInquiryYearlyHistory.ProductType, 
                                              ViewProjectInquiryYearlyHistory.ProductTypeID, ViewProjectInquiryYearlyHistory.LostPercentage, ViewProjectInquiryYearlyHistory.CancelledPercentage, 
                                              ViewProjectInquiryYearlyHistory.LateResponsePercentage, ViewProjectInquiryYearlyHistory.OrderChanceID, 
                                              ViewProjectInquiryYearlyHistory.OrderChance, ViewProjectInquiryYearlyHistory.InquiryHasGuarantee, ViewProjectInquiryYearlyHistory.InquiryType, 
                                              ViewProjectInquiryYearlyHistory.CurrencyCode AS QuotationCurrencyCode, Currencies.CurrencyCode AS LostWinnerPriceCurrencyCode, 
                                              ViewProjectInquiryYearlyHistory.ResponsibleEngineerID, ViewProjectInquiryYearlyHistory.Year, ViewProjectInquiryYearlyHistory.BranchID , Row_Number() OVER (PARTITION BY 
                                              dbo.ViewProjectInquiryYearlyHistory.ProjectSerialNumber
                       ORDER BY dbo.ViewProjectInquiryYearlyHistory.ProjectSerialNumber) AS row
FROM         LostReasons INNER JOIN
                      LostsYearlyHistory ON LostReasons.ID = LostsYearlyHistory.LostReasonID LEFT OUTER JOIN
                      Currencies ON LostsYearlyHistory.LostPriceCurrencyID = Currencies.ID AND LostsYearlyHistory.WinnerPriceCurrencyID = Currencies.ID RIGHT OUTER JOIN
                      ViewProjectInquiryYearlyHistory ON LostsYearlyHistory.InquiryNumber = ViewProjectInquiryYearlyHistory.ProjectSerialNumber) AS t
WHERE     t .row = 1

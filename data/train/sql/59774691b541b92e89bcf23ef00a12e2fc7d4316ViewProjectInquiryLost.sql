CREATE VIEW [dbo].[ViewProjectInquiryLost]
AS
SELECT     *
FROM         (SELECT     ViewProjectInquiry.ProjectSerialNumber, ViewProjectInquiry.ShotecNo, ViewProjectInquiry.ResponsibleEngineer, ViewProjectInquiry.ProjectID, 
                                              ViewProjectInquiry.ClientName, ViewProjectInquiry.CompanyCode, ViewProjectInquiry.ClientWebsite, ViewProjectInquiry.ClientInquiryNumber, 
                                              ViewProjectInquiry.InquiryDate, ViewProjectInquiry.ProjectStatus, ViewProjectInquiry.InquiryTypeID, ViewProjectInquiry.SupplierName, 
                                              ViewProjectInquiry.SupplierQuotationNumber, ViewProjectInquiry.QuotationPrice, ViewProjectInquiry.QuotationCurrency, 
                                              ViewProjectInquiry.QuotationRateToEURO, ViewProjectInquiry.QuotationRateDate, ViewProjectInquiry.QuotationPriceInEuro, ViewProjectInquiry.BidDueDate, 
                                              ViewProjectInquiry.OnHold, ViewProjectInquiry.ModifiedDate, ViewProjectInquiry.UserName, ViewProjectInquiry.ProjectName, 
                                              ViewProjectInquiry.ProjectLocation, ViewProjectInquiry.ProjectOwnerName, ViewProjectInquiry.ProjectDescription, ViewProjectInquiry.ProductName, 
                                              ViewProjectInquiry.CategoryName, ViewProjectInquiry.ProductDescription, ViewProjectInquiry.ProjectComment, ViewProjectInquiry.InquiryPaymentBaseID, 
                                              ViewProjectInquiry.InquiryPriceBaseID, LostReasons.ReasonName, LostReasons.ReasonCode, Losts.LostReasonID, 
                                              Losts.WinnerName AS LostWinnerName, Losts.WinnerPrice AS LostWinnerPrice, ViewProjectInquiry.ResponsibleEngineerDisplayName, 
                                              ViewProjectInquiry.LanguageId, Losts.WinnerPriceInEuro AS LostWinnerPriceInEuro, Losts.RateToEuro AS LostWinnerRateToEuro, 
                                              Losts.RateDate AS LostWinnerRateDate, Losts.WinnerPriceCurrencyID AS LostWinnerPriceCurrencyID, ViewProjectInquiry.InquiryStatus, 
                                              ViewProjectInquiry.OrderPercentage, ViewProjectInquiry.SupplierID, Losts.ModifiedDate AS LostDate, ViewProjectInquiry.ProjectTypeID, 
                                              ViewProjectInquiry.OfferDate, ViewProjectInquiry.ParentInquiryNumber, ViewProjectInquiry.IsSubOffer, Losts.IsSubLost, 
                                              Losts.ParentInquiryNumber AS LostParentInquiryNumber, ViewProjectInquiry.CustomerID, Losts.LostComment, ViewProjectInquiry.ProductType, 
                                              ViewProjectInquiry.ProductTypeID, ViewProjectInquiry.LostPercentage, ViewProjectInquiry.CancelledPercentage, 
                                              ViewProjectInquiry.LateResponsePercentage, ViewProjectInquiry.OrderChanceID, ViewProjectInquiry.OrderChance, 
                                              ViewProjectInquiry.InquiryHasGuarantee, ViewProjectInquiry.InquiryType, ViewProjectInquiry.BranchID, ViewProjectInquiry.BranchNameFL, 
                                              ViewProjectInquiry.BranchNameSL, ViewProjectInquiry.CountryID, ViewProjectInquiry.CountryName, 
                                              ViewProjectInquiry.CurrencyCode AS QuotationCurrencyCode, Currencies.CurrencyCode AS LostWinnerPriceCurrencyCode, 
                                              ViewProjectInquiry.ResponsibleEngineerID ,  ViewProjectInquiry.FileNo, Row_Number() OVER (PARTITION BY dbo.ViewProjectInquiry.ProjectSerialNumber
                       ORDER BY dbo.ViewProjectInquiry.ProjectSerialNumber) AS row
FROM         LostReasons INNER JOIN
                      Losts ON LostReasons.ID = Losts.LostReasonID LEFT OUTER JOIN
                      Currencies ON Losts.LostPriceCurrencyID = Currencies.ID AND Losts.WinnerPriceCurrencyID = Currencies.ID RIGHT OUTER JOIN
                      ViewProjectInquiry ON Losts.InquiryNumber = ViewProjectInquiry.ProjectSerialNumber) AS t
WHERE     t .row = 1

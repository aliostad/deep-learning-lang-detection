/*
 *
 * Automatically generated for MonoX installation
 *
 */

USE MonoX2;
GO


SET NOCOUNT ON
/* ======================================================================= */

PRINT N'Deleting existing values from [dbo].[NewsItem]';
DELETE FROM [dbo].[NewsItem];
GO

PRINT N'Inserting values into [dbo].[NewsItem]';

INSERT INTO [dbo].[NewsItem] ([Id],[NewsCategoryId],[UserId],[ShowOnHomePage],[Revision],[ShowTitle],[ShowShortContent],[ShowCategoryTitle],[ShowCategoryTitleAsLink],[ShowFullCategoryPath],[ShowUserName],[ShowDateEntered],[ShowDateModified],[ViewCount],[DateEntered],[DateModified],[VisibleDate]) VALUES ('3212B9B2-BF54-4C1D-9257-9E6300DF50B1','CDF073F2-9404-4B09-83AA-9E6300D5794E','67C919E2-8DF4-476A-B312-C26F82A36CFB',1,2,1,1,1,1,0,0,0,0,1,'2011-01-06T12:11:46.000','2011-01-06T12:31:28.000',
    '2011-01-06T12:11:46.000');
GO
INSERT INTO [dbo].[NewsItem] ([Id],[NewsCategoryId],[UserId],[ShowOnHomePage],[Revision],[ShowTitle],[ShowShortContent],[ShowCategoryTitle],[ShowCategoryTitleAsLink],[ShowFullCategoryPath],[ShowUserName],[ShowDateEntered],[ShowDateModified],[ViewCount],[DateEntered],[DateModified],[VisibleDate]) VALUES ('0E434B68-BE7E-4D15-BAB6-9E6300E524A0','CDF073F2-9404-4B09-83AA-9E6300D5794E','67C919E2-8DF4-476A-B312-C26F82A36CFB',1,1,1,1,1,1,0,0,0,0,NULL,'2011-01-06T12:30:51.000','2011-01-06T12:30:51.000',
    '2011-01-06T12:30:51.000');
GO
GO

SET NOCOUNT OFF
/* ======================================================================= */

PRINT N'Done.';


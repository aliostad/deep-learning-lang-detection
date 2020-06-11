CREATE TABLE [dbo].[plfPages] (
    [pageId]           INT            IDENTITY (1, 1) NOT NULL,
    [pageCode]         NVARCHAR (50)  NULL,
    [pageName]         NVARCHAR (255) NULL,
    [pageNavName]      NVARCHAR (255) NULL,
    [pageParentId]     INT            NULL,
    [pageDisplayOrder] INT            NULL,
    [pageIsVisible]    NVARCHAR (10)  NULL,
    [pageIsAdminOnly]  NVARCHAR (10)  NULL,
    CHECK ([pageIsVisible]='YES' OR [pageIsVisible]='NO'),
    CHECK ([pageIsAdminOnly]='YES' OR [pageIsAdminOnly]='NO')
);


SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[sys_CurrentObjectPropertyPermissions]
AS
SELECT   ObjectId, PropertyId, MAX(IsVisible) AS IsVisible, MIN(IsReadOnly) AS IsReadOnly
FROM     (SELECT   ObjectId, PropertyId, abs(cast(IsVisible AS tinyint)) AS IsVisible, abs(cast(IsReadOnly AS tinyint)) AS IsReadOnly
            FROM     sys_ObjectPropertyPermissions
            WHERE   TypeUID = 0 AND UID = dbo.sys_GetCurrentUserId()
            UNION ALL
            SELECT   ObjectId, PropertyId, abs(cast(IsVisible AS tinyint)) AS IsVisible, abs(cast(IsReadOnly AS tinyint)) AS IsReadOnly
            FROM     sys_ObjectPropertyPermissions
            WHERE   TypeUID = 1 AND UID IN
                         (SELECT   GroupId
                          FROM     sys_User2GroupRelations
                          WHERE   UserId = dbo.sys_GetCurrentUserId())) a
GROUP BY ObjectId, PropertyId
GO
GRANT SELECT ON  [dbo].[sys_CurrentObjectPropertyPermissions] TO [public]
GO

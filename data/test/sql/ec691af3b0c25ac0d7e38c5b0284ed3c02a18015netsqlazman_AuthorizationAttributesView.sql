CREATE VIEW [dbo].[netsqlazman_AuthorizationAttributesView]
AS
SELECT     dbo.[netsqlazman_AuthorizationView].AuthorizationId, dbo.[netsqlazman_AuthorizationView].ItemId, dbo.[netsqlazman_AuthorizationView].Owner, dbo.[netsqlazman_AuthorizationView].Name, dbo.[netsqlazman_AuthorizationView].objectSid, 
                      dbo.[netsqlazman_AuthorizationView].SidWhereDefined, dbo.[netsqlazman_AuthorizationView].AuthorizationType, dbo.[netsqlazman_AuthorizationView].ValidFrom, dbo.[netsqlazman_AuthorizationView].ValidTo, 
                      [netsqlazman_AuthorizationAttributes].AuthorizationAttributeId, [netsqlazman_AuthorizationAttributes].AttributeKey, [netsqlazman_AuthorizationAttributes].AttributeValue
FROM         dbo.[netsqlazman_AuthorizationView] INNER JOIN
                      dbo.[netsqlazman_AuthorizationAttributes]() [netsqlazman_AuthorizationAttributes] ON dbo.[netsqlazman_AuthorizationView].AuthorizationId = [netsqlazman_AuthorizationAttributes].AuthorizationId

GO
GRANT SELECT
    ON OBJECT::[dbo].[netsqlazman_AuthorizationAttributesView] TO [NetSqlAzMan_Readers]
    AS [dbo];


-- =============================================
-- Author:		Ken Taylor
-- Create date: February 5, 2014
-- Description:	Given a Kerberos/LoginId, Return a list of orders that the user has read access and edit access to.
--	Notes:
--		Replaces vAccess.
--		Determines access on any order (regardless of status).  Uses udf_GetEditAccessOrdersForLogin(@LoginId) and 
--			udf_GetReadAccessOrdersForLogin(@LoginId) user defined functions.
-- Usage:
/*
	select * from udf_GetReadAndEditAccessOrdersForLogin('bazemore') 
*/
-- =============================================
CREATE FUNCTION udf_GetReadAndEditAccessOrdersForLogin 
(
	-- Add the parameters for the function here
	@LoginId varchar(50) 
)
RETURNS 
@ReadAndEditAccessOrders TABLE 
(
	id int, 
	orderid int,
	accessuserid varchar(10),
	readaccess bit,
	editaccess bit,
	isadmin bit,
	accesslevel char(2)
)
AS
BEGIN
	INSERT INTO @ReadAndEditAccessOrders
	select ROW_NUMBER() over (order by orderid) id, access.orderid, access.accessuserid, cast(access.readaccess as bit) readaccess, cast(access.editaccess as bit) editaccess, access.isadmin, accesslevel
from
	(
		select orderid, accessuserid, 1 readaccess, 1 editaccess, isadmin, accesslevel
		from udf_GetEditAccessOrdersForLogin(@LoginId)

		union

		select orderid, accessuserid, 1 readaccess, 0 editaccess, isadmin, accesslevel
		from udf_GetReadAccessOrdersForLogin(@LoginId)
	) access
	
	RETURN 
END
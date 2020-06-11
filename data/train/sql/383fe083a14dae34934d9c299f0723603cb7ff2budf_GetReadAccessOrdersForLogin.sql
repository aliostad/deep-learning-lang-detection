-- =============================================
-- Author:		Ken Taylor
-- Create date: February 5, 2014
-- Description:	Given a Kerberos/LoginId Return a list of orders that the user has read access to.
--	Notes: 
--		Replaces vReadAccess.
--		Determines read access based on order tracking or reviewer role, regardless of order status.
-- Usage:
/*
	select * from udf_GetReadAccessOrdersForLogin('kdani')
*/
-- =============================================
CREATE FUNCTION udf_GetReadAccessOrdersForLogin 
(
	-- Add the parameters for the function here
	@LoginId varchar(50)
)
RETURNS 
@ReadAccessOrders TABLE 
(
	-- Add the column definitions for the TABLE variable here
	orderid int, 
	accessuserid varchar(10),
	isadmin bit,
	accesslevel char(2)
)
AS
BEGIN
	INSERT INTO @ReadAccessOrders
	select access.orderid, access.UserId accessuserid,	[admin] isadmin, OrderStatusCodeId accesslevel
	from
	(
		-- acted on order
		select orderid, userid, OrderStatusCodeId, 0 [admin]
		from ordertracking
		where userid = @LoginId

		union

		-- reviewer role
		select o.id orderid, wp.userid, wp.RoleId
			, cast (case when wp.isadmin = 1 and wp.isfullfeatured = 0 then 1 else 0 end as bit) [admin]
		from workgrouppermissions wp
			inner join orders o on o.WorkgroupId = wp.WorkgroupId
			inner join workgroups w on wp.workgroupid = w.id and w.IsActive = 1
		where 
			wp.userid = @LoginId
			and wp.roleid = 'RV'
) access
	
	RETURN 
END
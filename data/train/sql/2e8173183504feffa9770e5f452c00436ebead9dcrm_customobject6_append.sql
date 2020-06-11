create procedure dbo.crm_customobject6_append
(
	@ARTICLE_NAME	VARCHAR(32),
	@MAGAZINE	VARCHAR(32),
	@YEAR	VARCHAR(32),
	@VOLUME	VARCHAR(32),
	@SERIES	VARCHAR(32),
	@PAGE	VARCHAR(32),
	@OWNERID	VARCHAR(32),
	@HCP_ARTICLE_ID	VARCHAR(32),
	@HCP_ID	VARCHAR(32)
)
as
	insert into crm_custom_object_6
	(
		Name,
		CustomText30,
		QuickSearch1,
		QuickSearch2,
		CustomText31,
		CustomText32,
		OwnerID,
		ExternalSystemID,
		ContactExternalSystemId,
		dbstatus
	)
	values
	(
		@ARTICLE_NAME,
		@MAGAZINE,
		@YEAR,
		@VOLUME,
		@SERIES,
		@PAGE,
		@OWNERID,
		@HCP_ARTICLE_ID,
		@HCP_ID,
		10
	)
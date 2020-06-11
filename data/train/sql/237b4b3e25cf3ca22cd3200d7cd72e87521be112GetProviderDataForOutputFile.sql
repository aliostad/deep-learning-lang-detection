CREATE Proc [dbo].[GetProviderDataForOutputFile] (@filerequestid uniqueidentifier)
as 

Select
--Header names should map what's the output of the header
--place holder should map where columns should be. it will append additional data columsn at the end.
	ClientId,
	ProviderId,
	ProviderNumber,
	Name,
	Address1,
	Address2,
	City,
	[State],
	ZipCode,
	Phone,
	NPI,
	FederalTaxIdNumber,
	TaxonomyCode1,
	TaxonomyCode2,
	TaxonomyCode3,
	ProviderType,
	AdditionalDataJson
	
From
	Provider (NOLOCK)
WHere
	FileRequestId = @FileRequestId
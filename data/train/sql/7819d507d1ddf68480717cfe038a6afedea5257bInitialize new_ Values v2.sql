UPDATE [Productions_MSCRM].[dbo].[OpportunityExtensionBase]
SET [new_MaintenanceDollarsVerint] = ISNULL([new_SoftwareListPrice], 0.0) * 0.18 * 0.4 
	, [new_maintenancedollarsverint_Base] = ISNULL([new_softwarelistprice_Base], 0.0) * 0.18 * 0.4; 
GO

UPDATE [Productions_MSCRM].[dbo].[OpportunityExtensionBase]
SET [new_SoftwareDollarsVerint] = ISNULL([new_SoftwareListPrice], 0.0) * 0.4 
	, [new_softwaredollarsverint_Base] = ISNULL([new_softwarelistprice_Base], 0.0) * 0.4;
GO

UPDATE [Productions_MSCRM].[dbo].[OpportunityExtensionBase]
SET [new_SoftwareRevenue] = ISNULL([new_SoftwareListPrice], 0.0) * ( 1 - ISNULL([new_SoftwareDiscountPercentage], 0.0) / 100.0 )
	, [new_softwarerevenue_Base] = ISNULL([new_softwarelistprice_Base], 0.0) * ( 1 - ISNULL([new_SoftwareDiscountPercentage], 0.0) / 100.0 );
GO

UPDATE [Productions_MSCRM].[dbo].[OpportunityExtensionBase]
SET [new_TotalDollarsPartner] = ISNULL([new_SoftwareDollarsVerint], 0.0) + 
		ISNULL([new_MaintenanceDollarsVerint], 0.0) + 
		ISNULL([new_ServicesDollarstoPartner], 0.0) + 
		ISNULL([new_TrainingDollarstoPartner], 0.0)
	, [new_totaldollarspartner_Base] = ISNULL([new_softwaredollarsverint_Base], 0.0) + 
		ISNULL([new_maintenancedollarsverint_Base], 0.0) + 
		ISNULL([new_servicesdollarstopartner_Base], 0.0) + 
		ISNULL([new_trainingdollarstopartner_Base], 0.0);
GO

UPDATE [Productions_MSCRM].[dbo].[OpportunityExtensionBase]
SET [new_TotalRevenue] = ISNULL([new_HardwareRevenue], 0.0) + 
	ISNULL([new_SoftwareRevenue], 0.0) + 
	ISNULL([new_SoftwareMaintenanceRevenue], 0.0) + 
	ISNULL([new_TrainingRevenue], 0.0) + 
	ISNULL([new_HardwareSupportRevenue], 0.0) + 
	ISNULL([new_ServicesRevenue], 0.0) - 
	ISNULL([new_PreferredCustomerDiscount], 0.0) + 
	ISNULL([new_ServicesDollarstoPartner], 0.0)
	, [new_totalrevenue_Base] = ISNULL([new_HardwareRevenue_Base], 0.0) + 
	ISNULL([new_softwarerevenue_Base], 0.0) + 
	ISNULL([new_softwaremaintenancerevenue_Base], 0.0) + 
	ISNULL([new_trainingrevenue_Base], 0.0) + 
	ISNULL([new_hardwaresupportrevenue_Base], 0.0) + 
	ISNULL([new_servicesrevenue_Base], 0.0) - 
	ISNULL([new_preferredcustomerdiscount_Base], 0.0) + 
	ISNULL([new_servicesdollarstopartner_Base], 0.0);
GO

UPDATE [Productions_MSCRM].[dbo].[OpportunityExtensionBase] 
SET [new_TotalRevenue_Base] = ISNULL([new_TotalRevenue], 0.0)
GO


UPDATE E
SET [EstimatedValue] = ISNULL(TR.[new_TotalRevenue], 0.0)
	, [EstimatedValue_Base] = ISNULL(TR.[new_totalrevenue_Base], 0.0)
FROM [Productions_MSCRM].[dbo].[OpportunityBase] AS E, 
	[Productions_MSCRM].[dbo].[OpportunityExtensionBase] AS TR
WHERE E.OPPORTUNITYID = TR.OPPORTUNITYID;
GO

/* Upating Opportunities which are not closed yet */
UPDATE [Productions_MSCRM].[dbo].[OpportunityBase] 
SET [ActualValue] = ISNULL([EstimatedValue], 0.0)
	, [ActualValue_Base] = ISNULL([EstimatedValue_Base], 0.0)
WHERE [StatusCode] = 1;
GO

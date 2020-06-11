USE [Development_MSCRM];

UPDATE [Opportunity] SET [new_50ServicesRevenue] = 0 WHERE ISNUMERIC([new_ServicesRevenue]) = 0;	
UPDATE [Opportunity] SET [new_FirstYearRevenue] = 0 WHERE ISNUMERIC([new_FirstYearRevenue]) = 0;
UPDATE [Opportunity] SET [new_HardwareRevenue]  = 0 WHERE ISNUMERIC([new_HardwareRevenue]) = 0;
UPDATE [Opportunity] SET [new_HardwareSupportRevenue] = 0 WHERE ISNUMERIC([new_HardwareSupportRevenue]) = 0;
UPDATE [Opportunity] SET [new_partnerservicesrevenue] = 0 WHERE ISNUMERIC([new_partnerservicesrevenue]) = 0;
UPDATE [Opportunity] SET [new_PreferredCustomerDiscount] = 0 WHERE ISNUMERIC([new_PreferredCustomerDiscount]) = 0;
UPDATE [Opportunity] SET [new_ServicesDollarstoPartner] = 0 WHERE ISNUMERIC([new_ServicesDollarstoPartner]) = 0;
UPDATE [Opportunity] SET [new_ServicesRevenue] = 0 WHERE ISNUMERIC([new_ServicesRevenue]) = 0;
UPDATE [Opportunity] SET [new_SoftwareDiscountPercentage] = 0 WHERE ISNUMERIC([new_SoftwareDiscountPercentage]) = 0;
UPDATE [Opportunity] SET [new_SoftwareListPrice] = 0 WHERE ISNUMERIC([new_SoftwareListPrice]) = 0;
UPDATE [Opportunity] SET [new_SoftwareMaintenanceRevenue] = 0 WHERE ISNUMERIC([new_SoftwareMaintenanceRevenue]) = 0;
UPDATE [Opportunity] SET [new_SoftwareRevenue] = 0 WHERE ISNUMERIC([new_SoftwareRevenue]) = 0;
UPDATE [Opportunity] SET [new_TotalRevenue] = 0 WHERE ISNUMERIC([new_TotalRevenue]) = 0;
UPDATE [Opportunity] SET [new_TrainingDollarstoPartner] = 0 WHERE ISNUMERIC([new_TrainingDollarstoPartner]) = 0;
UPDATE [Opportunity] SET [new_TrainingRevenue] = 0 WHERE ISNUMERIC([new_TrainingRevenue]) = 0;

UPDATE [Opportunity] SET [new_50ServicesRevenue] = [new_ServicesRevenue] / 2.0;
UPDATE [Opportunity] SET [new_SoftwareRevenue] = [new_SoftwareListPrice] * ( 1.0 - [new_SoftwareDiscountPercentage] / 100.0 );
UPDATE [Opportunity] SET [new_HDPLUSWSWRevenue] = [new_HardwareRevenue] + [new_SoftwareRevenue];
UPDATE [Opportunity] SET [new_FutureAGSRevenueTotal] = [new_50ServicesRevenue] + [new_HDPLUSWSWRevenue];

UPDATE [Opportunity] SET [new_InitialVerintRevenue] = [new_TotalRevenue] - [new_50ServicesRevenue] - [new_HDPLUSWSWRevenue];

UPDATE [Opportunity] SET [new_MaintenanceDollarsVerint] = [new_SoftwareListPrice] *  0.18 * 0.4;
UPDATE [Opportunity] SET [new_SoftwareDollarsVerint] = [new_SoftwareListPrice] * 0.4;
UPDATE [Opportunity] SET [new_TotalDollarsPartner] = [new_SoftwareDollarsVerint] + 
	[new_MaintenanceDollarsVerint] + [new_ServicesDollarstoPartner] + [new_TrainingDollarstoPartner];

UPDATE [Opportunity] SET [new_TotalRevenue] = [new_HardwareRevenue] + [new_SoftwareRevenue] + [new_SoftwareMaintenanceRevenue] + 
	[new_TrainingRevenue] + [new_HardwareSupportRevenue] + [new_ServicesRevenue] + 
	[new_PreferredCustomerDiscount] + [new_FirstYearRevenue] + [new_partnerservicesrevenue];
GO

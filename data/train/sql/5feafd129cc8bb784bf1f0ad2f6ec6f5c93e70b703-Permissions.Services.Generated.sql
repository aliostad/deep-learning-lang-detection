IF NOT EXISTS(SELECT * FROM [Auth].[Permission] WHERE [PermissionName] = 'Client_Candidates_Exists' )
	INSERT INTO [Auth].[Permission] ([PermissionName],[Title],[IsRead]) VALUES ('Client_Candidates_Exists', 'Client Candidates Exists',1);
IF NOT EXISTS(SELECT * FROM [Auth].[Permission] WHERE [PermissionName] = 'Client_Candidates_Search' )
	INSERT INTO [Auth].[Permission] ([PermissionName],[Title],[IsRead]) VALUES ('Client_Candidates_Search', 'Client Candidates Search',1);
IF NOT EXISTS(SELECT * FROM [Auth].[Permission] WHERE [PermissionName] = 'Client_Candidates_SelectAll' )
	INSERT INTO [Auth].[Permission] ([PermissionName],[Title],[IsRead]) VALUES ('Client_Candidates_SelectAll', 'Client Candidates SelectAll',1);
IF NOT EXISTS(SELECT * FROM [Auth].[Permission] WHERE [PermissionName] = 'Client_Candidates_SelectBy_CandidateId' )
	INSERT INTO [Auth].[Permission] ([PermissionName],[Title],[IsRead]) VALUES ('Client_Candidates_SelectBy_CandidateId', 'Client Candidates SelectBy CandidateId',1);
IF NOT EXISTS(SELECT * FROM [Auth].[Permission] WHERE [PermissionName] = 'Client_Candidates_SelectBy_ContentInspectionId' )
	INSERT INTO [Auth].[Permission] ([PermissionName],[Title],[IsRead]) VALUES ('Client_Candidates_SelectBy_ContentInspectionId', 'Client Candidates SelectBy ContentInspectionId',1);
IF NOT EXISTS(SELECT * FROM [Auth].[Permission] WHERE [PermissionName] = 'Client_Candidates_SelectBy_OrganizationId' )
	INSERT INTO [Auth].[Permission] ([PermissionName],[Title],[IsRead]) VALUES ('Client_Candidates_SelectBy_OrganizationId', 'Client Candidates SelectBy OrganizationId',1);
IF NOT EXISTS(SELECT * FROM [Auth].[Permission] WHERE [PermissionName] = 'Client_Candidates_SelectBy_ProposedByUserId' )
	INSERT INTO [Auth].[Permission] ([PermissionName],[Title],[IsRead]) VALUES ('Client_Candidates_SelectBy_ProposedByUserId', 'Client Candidates SelectBy ProposedByUserId',1);
IF NOT EXISTS(SELECT * FROM [Auth].[Permission] WHERE [PermissionName] = 'Client_Candidates_SelectBy_ConfirmedByUserId' )
	INSERT INTO [Auth].[Permission] ([PermissionName],[Title],[IsRead]) VALUES ('Client_Candidates_SelectBy_ConfirmedByUserId', 'Client Candidates SelectBy ConfirmedByUserId',1);
IF NOT EXISTS(SELECT * FROM [Auth].[Permission] WHERE [PermissionName] = 'Client_Locations_Exists' )
	INSERT INTO [Auth].[Permission] ([PermissionName],[Title],[IsRead]) VALUES ('Client_Locations_Exists', 'Client Locations Exists',1);
IF NOT EXISTS(SELECT * FROM [Auth].[Permission] WHERE [PermissionName] = 'Client_Locations_Search' )
	INSERT INTO [Auth].[Permission] ([PermissionName],[Title],[IsRead]) VALUES ('Client_Locations_Search', 'Client Locations Search',1);
IF NOT EXISTS(SELECT * FROM [Auth].[Permission] WHERE [PermissionName] = 'Client_Locations_SelectAll' )
	INSERT INTO [Auth].[Permission] ([PermissionName],[Title],[IsRead]) VALUES ('Client_Locations_SelectAll', 'Client Locations SelectAll',1);
IF NOT EXISTS(SELECT * FROM [Auth].[Permission] WHERE [PermissionName] = 'Client_Locations_SelectBy_LocationId' )
	INSERT INTO [Auth].[Permission] ([PermissionName],[Title],[IsRead]) VALUES ('Client_Locations_SelectBy_LocationId', 'Client Locations SelectBy LocationId',1);
IF NOT EXISTS(SELECT * FROM [Auth].[Permission] WHERE [PermissionName] = 'Client_Locations_SelectBy_ContentInspectionId' )
	INSERT INTO [Auth].[Permission] ([PermissionName],[Title],[IsRead]) VALUES ('Client_Locations_SelectBy_ContentInspectionId', 'Client Locations SelectBy ContentInspectionId',1);
IF NOT EXISTS(SELECT * FROM [Auth].[Permission] WHERE [PermissionName] = 'Client_Locations_SelectBy_ProposedByUserId' )
	INSERT INTO [Auth].[Permission] ([PermissionName],[Title],[IsRead]) VALUES ('Client_Locations_SelectBy_ProposedByUserId', 'Client Locations SelectBy ProposedByUserId',1);
IF NOT EXISTS(SELECT * FROM [Auth].[Permission] WHERE [PermissionName] = 'Client_Locations_SelectBy_ConfirmedByUserId' )
	INSERT INTO [Auth].[Permission] ([PermissionName],[Title],[IsRead]) VALUES ('Client_Locations_SelectBy_ConfirmedByUserId', 'Client Locations SelectBy ConfirmedByUserId',1);
IF NOT EXISTS(SELECT * FROM [Auth].[Permission] WHERE [PermissionName] = 'Client_Organizations_SelectAll' )
	INSERT INTO [Auth].[Permission] ([PermissionName],[Title],[IsRead]) VALUES ('Client_Organizations_SelectAll', 'Client Organizations SelectAll',1);
IF NOT EXISTS(SELECT * FROM [Auth].[Permission] WHERE [PermissionName] = 'Client_Organizations_Exists' )
	INSERT INTO [Auth].[Permission] ([PermissionName],[Title],[IsRead]) VALUES ('Client_Organizations_Exists', 'Client Organizations Exists',1);
IF NOT EXISTS(SELECT * FROM [Auth].[Permission] WHERE [PermissionName] = 'Client_Organizations_Search' )
	INSERT INTO [Auth].[Permission] ([PermissionName],[Title],[IsRead]) VALUES ('Client_Organizations_Search', 'Client Organizations Search',1);
IF NOT EXISTS(SELECT * FROM [Auth].[Permission] WHERE [PermissionName] = 'Client_Organizations_SelectBy_OrganizationId' )
	INSERT INTO [Auth].[Permission] ([PermissionName],[Title],[IsRead]) VALUES ('Client_Organizations_SelectBy_OrganizationId', 'Client Organizations SelectBy OrganizationId',1);
IF NOT EXISTS(SELECT * FROM [Auth].[Permission] WHERE [PermissionName] = 'Client_Organizations_SelectBy_ContentInspectionId' )
	INSERT INTO [Auth].[Permission] ([PermissionName],[Title],[IsRead]) VALUES ('Client_Organizations_SelectBy_ContentInspectionId', 'Client Organizations SelectBy ContentInspectionId',1);
IF NOT EXISTS(SELECT * FROM [Auth].[Permission] WHERE [PermissionName] = 'Client_Organizations_SelectBy_ProposedByUserId' )
	INSERT INTO [Auth].[Permission] ([PermissionName],[Title],[IsRead]) VALUES ('Client_Organizations_SelectBy_ProposedByUserId', 'Client Organizations SelectBy ProposedByUserId',1);
IF NOT EXISTS(SELECT * FROM [Auth].[Permission] WHERE [PermissionName] = 'Client_Organizations_SelectBy_ConfirmedByUserId' )
	INSERT INTO [Auth].[Permission] ([PermissionName],[Title],[IsRead]) VALUES ('Client_Organizations_SelectBy_ConfirmedByUserId', 'Client Organizations SelectBy ConfirmedByUserId',1);
IF NOT EXISTS(SELECT * FROM [Auth].[Permission] WHERE [PermissionName] = 'Client_Users_SelectByUser_Current' )
	INSERT INTO [Auth].[Permission] ([PermissionName],[Title],[IsRead]) VALUES ('Client_Users_SelectByUser_Current', 'Client Users SelectByUser Current',1);
IF NOT EXISTS(SELECT * FROM [Auth].[Permission] WHERE [PermissionName] = 'Client_Users_SelectByUser_UpdateProfile' )
	INSERT INTO [Auth].[Permission] ([PermissionName],[Title],[IsRead]) VALUES ('Client_Users_SelectByUser_UpdateProfile', 'Client Users SelectByUser UpdateProfile',1);
IF NOT EXISTS(SELECT * FROM [Auth].[Permission] WHERE [PermissionName] = 'Client_Users_Exists' )
	INSERT INTO [Auth].[Permission] ([PermissionName],[Title],[IsRead]) VALUES ('Client_Users_Exists', 'Client Users Exists',1);
IF NOT EXISTS(SELECT * FROM [Auth].[Permission] WHERE [PermissionName] = 'Client_Users_Search' )
	INSERT INTO [Auth].[Permission] ([PermissionName],[Title],[IsRead]) VALUES ('Client_Users_Search', 'Client Users Search',1);
IF NOT EXISTS(SELECT * FROM [Auth].[Permission] WHERE [PermissionName] = 'Client_Users_SelectAll' )
	INSERT INTO [Auth].[Permission] ([PermissionName],[Title],[IsRead]) VALUES ('Client_Users_SelectAll', 'Client Users SelectAll',1);

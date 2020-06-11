/******************************************************************************
**		File: access.sql
**		Name: sales access
**		Desc: sales access
**
**		Auth: Lemuel E. Aceron
**		Date: 
*******************************************************************************
**		Change History
*******************************************************************************
**		Date:		Author:				Description:
**		--------		--------				-------------------------------------------
**    
*******************************************************************************/ 

/*****************************
**	Added on October 9, 2007 for Sales
**	Lemuel E. Aceron
*****************************/
DELETE FROM sysAccessRights WHERE TranTypeID in (104, 107, 108, 109, 110, 111);
DELETE FROM sysAccessGroupRights WHERE TranTypeID in (104, 107, 108, 109, 110, 111);
DELETE FROM sysAccessTypes WHERE TypeID in (104, 107, 108, 109, 110, 111);

INSERT INTO sysAccessTypes (TypeID, TypeName) VALUES (104, 'Sales & Receivable Menu');
INSERT INTO sysAccessTypes (TypeID, TypeName) VALUES (107, 'Sales Orders');
INSERT INTO sysAccessTypes (TypeID, TypeName) VALUES (108, 'Sales Journals');
INSERT INTO sysAccessTypes (TypeID, TypeName) VALUES (109, 'Sales Returns');
INSERT INTO sysAccessTypes (TypeID, TypeName) VALUES (110, 'SalesCreditMemos');
INSERT INTO sysAccessTypes (TypeID, TypeName) VALUES (111, 'Sales And Receivables Menu');

INSERT INTO sysAccessGroupRights (GroupID, TranTypeID, AllowRead, AllowWrite) VALUES (1, 104, 1, 1);
INSERT INTO sysAccessGroupRights (GroupID, TranTypeID, AllowRead, AllowWrite) VALUES (1, 107, 1, 1);
INSERT INTO sysAccessGroupRights (GroupID, TranTypeID, AllowRead, AllowWrite) VALUES (1, 108, 1, 1);
INSERT INTO sysAccessGroupRights (GroupID, TranTypeID, AllowRead, AllowWrite) VALUES (1, 109, 1, 1);
INSERT INTO sysAccessGroupRights (GroupID, TranTypeID, AllowRead, AllowWrite) VALUES (1, 110, 1, 1);
INSERT INTO sysAccessGroupRights (GroupID, TranTypeID, AllowRead, AllowWrite) VALUES (1, 111, 1, 1);

INSERT INTO sysAccessRights (UID, TranTypeID, AllowRead, AllowWrite) VALUES (1, 104, 1, 1);
INSERT INTO sysAccessRights (UID, TranTypeID, AllowRead, AllowWrite) VALUES (1, 107, 1, 1);
INSERT INTO sysAccessRights (UID, TranTypeID, AllowRead, AllowWrite) VALUES (1, 108, 1, 1);
INSERT INTO sysAccessRights (UID, TranTypeID, AllowRead, AllowWrite) VALUES (1, 109, 1, 1);
INSERT INTO sysAccessRights (UID, TranTypeID, AllowRead, AllowWrite) VALUES (1, 110, 1, 1);
INSERT INTO sysAccessRights (UID, TranTypeID, AllowRead, AllowWrite) VALUES (1, 111, 1, 1);

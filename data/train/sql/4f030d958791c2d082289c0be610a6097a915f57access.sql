INSERT INTO sysAccessTypes (TypeID, TypeName) VALUES (95, 'GRN');
INSERT INTO sysAccessTypes (TypeID, TypeName) VALUES (96, 'Accounts Payable');
INSERT INTO sysAccessTypes (TypeID, TypeName) VALUES (97, 'PostingDates');
INSERT INTO sysAccessTypes (TypeID, TypeName) VALUES (98, 'PurchaseAnalysis');
INSERT INTO sysAccessTypes (TypeID, TypeName) VALUES (99, 'AccountSummary');
INSERT INTO sysAccessTypes (TypeID, TypeName) VALUES (100, 'AccountCategory');
INSERT INTO sysAccessTypes (TypeID, TypeName) VALUES (101, 'ChartOfAccounts');
INSERT INTO sysAccessTypes (TypeID, TypeName) VALUES (102, 'Payment Journals');
INSERT INTO sysAccessTypes (TypeID, TypeName) VALUES (103, 'General Ledger Menu');

UPDATE sysAccessTypes SET SequenceNo = 1, Category = '09: Backend - General Ledger' WHERE TypeID = 99;
UPDATE sysAccessTypes SET SequenceNo = 2, Category = '09: Backend - General Ledger' WHERE TypeID = 100;
UPDATE sysAccessTypes SET SequenceNo = 3, Category = '09: Backend - General Ledger' WHERE TypeID = 101;
UPDATE sysAccessTypes SET SequenceNo = 4, Category = '09: Backend - General Ledger' WHERE TypeID = 97;
UPDATE sysAccessTypes SET SequenceNo = 5, Category = '09: Backend - General Ledger' WHERE TypeID = 102;
UPDATE sysAccessTypes SET SequenceNo = 6, Category = '09: Backend - General Ledger' WHERE TypeID = 98;
UPDATE sysAccessTypes SET SequenceNo = 7, Category = '09: Backend - General Ledger' WHERE TypeID = 96;
UPDATE sysAccessTypes SET SequenceNo = 8, Category = '09: Backend - General Ledger' WHERE TypeID = 95;

INSERT INTO sysAccessGroupRights (GroupID, TranTypeID, AllowRead, AllowWrite) VALUES (1, 95, 1, 1);
INSERT INTO sysAccessGroupRights (GroupID, TranTypeID, AllowRead, AllowWrite) VALUES (1, 96, 1, 1);
INSERT INTO sysAccessGroupRights (GroupID, TranTypeID, AllowRead, AllowWrite) VALUES (1, 97, 1, 1);
INSERT INTO sysAccessGroupRights (GroupID, TranTypeID, AllowRead, AllowWrite) VALUES (1, 98, 1, 1);
INSERT INTO sysAccessGroupRights (GroupID, TranTypeID, AllowRead, AllowWrite) VALUES (1, 99, 1, 1);
INSERT INTO sysAccessGroupRights (GroupID, TranTypeID, AllowRead, AllowWrite) VALUES (1, 100, 1, 1);
INSERT INTO sysAccessGroupRights (GroupID, TranTypeID, AllowRead, AllowWrite) VALUES (1, 101, 1, 1);
INSERT INTO sysAccessGroupRights (GroupID, TranTypeID, AllowRead, AllowWrite) VALUES (1, 102, 1, 1);
INSERT INTO sysAccessGroupRights (GroupID, TranTypeID, AllowRead, AllowWrite) VALUES (1, 103, 1, 1);


INSERT INTO sysAccessRights (UID, TranTypeID, AllowRead, AllowWrite) VALUES (1, 95, 1, 1);
INSERT INTO sysAccessRights (UID, TranTypeID, AllowRead, AllowWrite) VALUES (1, 96, 1, 1);
INSERT INTO sysAccessRights (UID, TranTypeID, AllowRead, AllowWrite) VALUES (1, 97, 1, 1);
INSERT INTO sysAccessRights (UID, TranTypeID, AllowRead, AllowWrite) VALUES (1, 98, 1, 1);
INSERT INTO sysAccessRights (UID, TranTypeID, AllowRead, AllowWrite) VALUES (1, 99, 1, 1);
INSERT INTO sysAccessRights (UID, TranTypeID, AllowRead, AllowWrite) VALUES (1, 100, 1, 1);
INSERT INTO sysAccessRights (UID, TranTypeID, AllowRead, AllowWrite) VALUES (1, 101, 1, 1);
INSERT INTO sysAccessRights (UID, TranTypeID, AllowRead, AllowWrite) VALUES (1, 102, 1, 1);
INSERT INTO sysAccessRights (UID, TranTypeID, AllowRead, AllowWrite) VALUES (1, 103, 1, 1);

/**************************************************************
** January 9, 2009
** Lemuel E. Aceron
**
** 1.For accounting entries
**	 
**
**************************************************************/
INSERT INTO sysAccessTypes (TypeID, TypeName) VALUES (122, 'ItemSetupFinancial');
INSERT INTO sysAccessTypes (TypeID, TypeName) VALUES (123, 'APLinkConfig');
UPDATE sysAccessTypes SET SequenceNo = 11, Category = '09: Backend - General Ledger' WHERE TypeID = 122;
UPDATE sysAccessTypes SET SequenceNo = 12, Category = '09: Backend - General Ledger' WHERE TypeID = 123;

INSERT INTO sysAccessGroupRights (GroupID, TranTypeID, AllowRead, AllowWrite) VALUES (1, 122, 1, 1);
INSERT INTO sysAccessGroupRights (GroupID, TranTypeID, AllowRead, AllowWrite) VALUES (1, 123, 1, 1);
INSERT INTO sysAccessRights (UID, TranTypeID, AllowRead, AllowWrite) VALUES (1, 122, 1, 1);
INSERT INTO sysAccessRights (UID, TranTypeID, AllowRead, AllowWrite) VALUES (1, 123, 1, 1);

/******************************
 * For AccountingSystem
 * Added: March 17,2010 Lemuel E. Aceron
 * ******************************/
INSERT INTO sysAccessTypes (TypeID, TypeName) VALUES (128, 'Bank Deposits');
INSERT INTO sysAccessTypes (TypeID, TypeName) VALUES (129, 'Write Cheques');
INSERT INTO sysAccessTypes (TypeID, TypeName) VALUES (130, 'Fund Transfers');
INSERT INTO sysAccessTypes (TypeID, TypeName) VALUES (131, 'Reconcile Accounts');

UPDATE sysAccessTypes SET SequenceNo = 13,  Category = '09: Backend - General Ledger' WHERE TypeID = 128;
UPDATE sysAccessTypes SET SequenceNo = 14, Category = '09: Backend - General Ledger' WHERE TypeID = 129;
UPDATE sysAccessTypes SET SequenceNo = 15, Category = '09: Backend - General Ledger' WHERE TypeID = 130;
UPDATE sysAccessTypes SET SequenceNo = 16, Category = '09: Backend - General Ledger' WHERE TypeID = 131;

INSERT INTO sysAccessGroupRights (GroupID, TranTypeID, AllowRead, AllowWrite) VALUES (1, 128, 1, 1);
INSERT INTO sysAccessGroupRights (GroupID, TranTypeID, AllowRead, AllowWrite) VALUES (1, 129, 1, 1);
INSERT INTO sysAccessGroupRights (GroupID, TranTypeID, AllowRead, AllowWrite) VALUES (1, 130, 1, 1);
INSERT INTO sysAccessGroupRights (GroupID, TranTypeID, AllowRead, AllowWrite) VALUES (1, 131, 1, 1);

INSERT INTO sysAccessRights (UID, TranTypeID, AllowRead, AllowWrite) VALUES (1, 128, 1, 1);
INSERT INTO sysAccessRights (UID, TranTypeID, AllowRead, AllowWrite) VALUES (1, 129, 1, 1);
INSERT INTO sysAccessRights (UID, TranTypeID, AllowRead, AllowWrite) VALUES (1, 130, 1, 1);
INSERT INTO sysAccessRights (UID, TranTypeID, AllowRead, AllowWrite) VALUES (1, 131, 1, 1);

/******************************
 * For AccountingSystem
 * Added: April 10,2010 Lemuel E. Aceron
 * ******************************/
INSERT INTO sysAccessTypes (TypeID, TypeName) VALUES (132, 'General Journal');

UPDATE sysAccessTypes SET SequenceNo = 17,  Category = '09: Backend - General Ledger' WHERE TypeID = 132;

INSERT INTO sysAccessGroupRights (GroupID, TranTypeID, AllowRead, AllowWrite) VALUES (1, 132, 1, 1);

INSERT INTO sysAccessRights (UID, TranTypeID, AllowRead, AllowWrite) VALUES (1, 132, 1, 1);
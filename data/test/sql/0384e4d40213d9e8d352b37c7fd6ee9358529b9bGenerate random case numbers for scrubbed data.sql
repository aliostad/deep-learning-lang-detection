/*** Script to load initial scrbu values into dbo.Random_CaseNos
Created: 02/07/2012
by: CJB
***/
/** create table **/
CREATE TABLE Random_CaseNos (
	Orig_Recip_Case_no VARBINARY(100)
	,New_CaseNo VARCHAR(15)
	,payee_name VARCHAR(35)
	,Payee_Addr_1 VARCHAR(30)
	,Payee_Addr_2 VARCHAR(30)
	,Recip_Addr_Line1 VARCHAR(35)
	,DOL_Injury_Date VARCHAR(6)
	)

/** insert encrypted values to link by **/
INSERT Random_CaseNos (orig_Recip_Case_no)
SELECT DISTINCT [encr_W1111013-RECIP-CASE]
FROM elig_base_ebcdic

/** generate new case no and append same 'end' of caseno in original data to ensure proper subsystem referenced **/
OPEN SYMMETRIC KEY EBCDICKEY DECRYPTION BY CERTIFICATE EBCDIC_Encrypt;
GO

UPDATE Random_CaseNos
SET 
New_CaseNo = left(convert(VARCHAR, DECRYPTBYKEY(Recip_Case_no)), 2) + right(replicate('0', 7) + convert(VARCHAR, (ABS(CHECKSUM(NewId())) % 1000000000)), 7) ,
DOL_Injury_Date = '+' + convert(varchar,(ABS(CAST(CAST(NewID() AS BINARY (8)) AS INT)) % datediff(d,'1/1/2011','1/1/1972')))


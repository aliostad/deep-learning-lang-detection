--Update description for existing forward calculations to read BF24
update .dbo.CALC_LIST 
set calc_name = 'P/NAV BF24' where calc_num = 238
update .dbo.DATA_MASTER 
set DATA_DESC = 'P/NAV BF24' where DATA_ID = 238

update .dbo.CALC_LIST 
set calc_name = 'P/Revenue BF24' where calc_num = 197
update .dbo.DATA_MASTER 
set DATA_DESC = 'P/Revenue BF24' where DATA_ID = 197

update .dbo.CALC_LIST 
set calc_name = 'P/Embedded Value BF24' where calc_num = 245
update .dbo.DATA_MASTER 
set DATA_DESC = 'P/Embedded Value BF24' where DATA_ID = 245

update .dbo.CALC_LIST 
set calc_name = 'P/Appraisal Value BF24' where calc_num = 239
update .dbo.DATA_MASTER 
set DATA_DESC = 'P/Appraisal Value BF24' where DATA_ID = 239


  update [dbo].[UserListDataPointMappingInfo]
  set DataDescription = 'P/NAV BF24' where DataDescription = 'Forward P/NAV'
  
  update [dbo].[UserListDataPointMappingInfo]
  set DataDescription = 'P/Revenue BF24' where DataDescription = 'Forward P/Revenue'
  
  update [dbo].[UserListDataPointMappingInfo]
  set DataDescription = 'P/Embedded Value BF24' where DataDescription = 'Forward P/Embedded Value'
  
 update [dbo].[UserListDataPointMappingInfo]
 set DataDescription = 'P/Appraisal Value BF24' where DataDescription = 'Forward P/Appraisal Value'
 
 

--Change calc_seq for 234
update dbo.CALC_LIST
set CALC_SEQ = 1, ACTIVE = 'Y' where CALC_NUM = 234

--Change calc_seq for 240
update dbo.CALC_LIST
set CALC_SEQ = 1, ACTIVE = 'Y' where CALC_NUM = 240

--Change calc_seq for 172
update dbo.CALC_LIST
set CALC_SEQ = 2, ACTIVE = 'Y', PRICEBASED = 'Y' where CALC_NUM = 172

--Change calc_seq for 219
update dbo.CALC_LIST
set CALC_SEQ = 2, ACTIVE = 'Y', PRICEBASED = 'Y'  where CALC_NUM = 219

--Change calc_seq for 235
update dbo.CALC_LIST
set CALC_SEQ = 1, ACTIVE = 'Y', PRICEBASED = 'N'  where CALC_NUM = 235

--Change calc_seq for 228
update dbo.CALC_LIST
set CALC_SEQ = 2, ACTIVE = 'Y', PRICEBASED = 'Y'  where CALC_NUM = 228

--Change calc_seq for 197
update dbo.CALC_LIST
set CALC_SEQ = 1, ACTIVE = 'Y', PRICEBASED = 'Y'  where CALC_NUM = 197

--Change calc_seq for 239
update dbo.CALC_LIST
set CALC_SEQ = 1, ACTIVE = 'Y', PRICEBASED = 'Y'  where CALC_NUM = 239

--Change calc_seq for 245
update dbo.CALC_LIST
set CALC_SEQ = 1, ACTIVE = 'Y', PRICEBASED = 'Y'  where CALC_NUM = 245

--Change calc_seq for 182
update dbo.CALC_LIST
set CALC_SEQ = 1, ACTIVE = 'Y', PRICEBASED = 'N'  where CALC_NUM = 182

--Change calc_seq for 183
update dbo.CALC_LIST
set CALC_SEQ = 1, ACTIVE = 'Y', PRICEBASED = 'N'  where CALC_NUM = 183

--Change calc_seq for 6
update dbo.CALC_LIST
set CALC_SEQ = 1, ACTIVE = 'Y', PRICEBASED = 'N'  where CALC_NUM = 6

--Change calc_seq for 226
update dbo.CALC_LIST
set CALC_SEQ = 2, ACTIVE = 'Y', PRICEBASED = 'N'  where CALC_NUM = 226

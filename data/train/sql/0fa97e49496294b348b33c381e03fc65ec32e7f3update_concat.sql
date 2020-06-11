-- This avoids subselects when updating columns when you want to ADD to what is already there.
-- update tblmaster set industry = concat(`industry`, " stock trader, home owner, invest, stocks, bonds, mutual funds, real estate, donor, credit worthy, over $200000 per year, mail order buyer") where custid = 100000 ;



INSERT DELAYED INTO tblmaster (custid,email,firstname, middlename,lastname,address,address2,city,county,region,zipcode,gender,companyname,jobtitle,industry,phonearea,phonenum,born,source,dtTimeStamp,dateadded,ip,domain,exclude,Confirmed,ConfirmedIP,ConfirmedTS,Opener,OpenerIP,OpenerTS,Clicker,ClickerIP,ClickerTS,country_short,keywords) SELECT tblmaster_old.custid,tblmaster_old.email,tblmaster_old.firstname, tblmaster_old.middlename, tblmaster_old.lastname, tblmaster_old.address, tblmaster_old.address2, tblmaster_old.city, tblmaster_old.county, tblmaster_old.region, tblmaster_old.zipcode, tblmaster_old.gender, tblmaster_old.companyname, tblmaster_old.jobtitle, tblmaster_old.industry,tblmaster_old.phonearea,tblmaster_old.phonenum,tblmaster_old.born,tblmaster_old.source,tblmaster_old.dtTimeStamp,tblmaster_old.dateadded,tblmaster_old.ip,tblmaster_old.domain,tblmaster_old.exclude,tblmaster_old.Confirmed,tblmaster_old.ConfirmedIP,tblmaster_old.ConfirmedTS,tblmaster_old.Opener,tblmaster_old.OpenerIP,tblmaster_old.OpenerTS,tblmaster_old.Clicker,tblmaster_old.ClickerIP,tblmaster_old.ClickerTS,tblmaster_old.country_short, tblmaster_old.keywords FROM tblmaster_old   
ON DUPLICATE KEY UPDATE 
tblmaster.firstname = IF(tblmaster.firstname = '', tblmaster_old.firstname,  IF(tblmaster_old.firstname <> '', tblmaster_old.firstname, tblmaster.firstname)), 
tblmaster.lastname = IF(tblmaster.lastname = '', tblmaster_old.lastname, IF(tblmaster_old.lastname <>'', tblmaster_old.lastname, tblmaster.lastname)), 
tblmaster.address = IF(tblmaster.address = '', tblmaster_old.address, IF(tblmaster_old.address <> '', tblmaster_old.address, tblmaster.address)), 
tblmaster.address2 = IF(tblmaster.address2 = '', tblmaster_old.address2, IF(tblmaster_old.address2 <> '', tblmaster_old.address2, tblmaster.address2)), 
tblmaster.city = IF(tblmaster.city = '', tblmaster_old.city, IF(tblmaster_old.city <> '', tblmaster_old.city, tblmaster.city)), 
tblmaster.county = IF(tblmaster.county = '', tblmaster_old.county, IF(tblmaster_old.county <> '', tblmaster_old.county, tblmaster.county)), 
tblmaster.region = IF(tblmaster.region = '' , tblmaster_old.region, IF(tblmaster_old.region <>'', tblmaster_old.region, tblmaster.region)), 
tblmaster.zipcode = IF(tblmaster.zipcode = '', tblmaster_old.zipcode, IF(tblmaster_old.zipcode <> '', tblmaster_old.zipcode, tblmaster.zipcode)), 
tblmaster.gender = IF(tblmaster.gender = '', tblmaster_old.gender,  tblmaster.gender), 
tblmaster.companyname = IF(tblmaster.companyname = '', tblmaster_old.companyname, IF(tblmaster_old.companyname <> '', CONCAT(tblmaster_old.companyname,' ', tblmaster.companyname), tblmaster.companyname)), 
tblmaster.jobtitle = IF(tblmaster.jobtitle = '', tblmaster_old.jobtitle, IF(tblmaster_old.jobtitle <> '',  CONCAT(tblmaster.jobtitle, ' ', tblmaster_old.jobtitle), tblmaster.jobtitle)), 
tblmaster.industry = IF(tblmaster.industry = '',  tblmaster_old.industry, IF(tblmaster_old.industry <> '', CONCAT(tblmaster.industry,' ', tblmaster_old.industry), tblmaster.industry)), 
tblmaster.phonearea = IF(tblmaster.phonearea = '', tblmaster_old.phonearea, tblmaster.phonearea ), 
tblmaster.phonenum = IF(tblmaster.phonenum = '', tblmaster_old.phonenum, tblmaster.phonenum ), 
tblmaster.born = IF(tblmaster.born = 0000-00-00, tblmaster_old.born, tblmaster.born ), 
tblmaster.source = IF(tblmaster.source = '', tblmaster_old.source, tblmaster.source ), 
tblmaster.dtTimeStamp = IF(tblmaster.dtTimeStamp = '0000-00-00 00:00:00', tblmaster_old.dtTimeStamp, tblmaster.dtTimeStamp), 
tblmaster.dateadded = IF(tblmaster.dateadded = '0000-00-00', tblmaster_old.dateadded, tblmaster.dateadded ), 
tblmaster.ip = IF(tblmaster.ip = 0, tblmaster_old.ip, tblmaster.ip), 
tblmaster.keywords = IF(tblmaster.keywords = '', tblmaster_old.keywords, IF(tblmaster_old.keywords <> '', CONCAT(tblmaster.keywords,' ',tblmaster_old.keywords), tblmaster.keywords)) 
 ;


INSERT DELAYED INTO tblmaster (custid,email,email_hash,firstname, middlename,lastname,address,address2,city,county,region,zipcode,gender,companyname,jobtitle,industry,phonearea,phonenum,born,source,dtTimeStamp,dateadded,ip,domain,exclude,Confirmed,ConfirmedIP,ConfirmedTS,Opener,OpenerIP,OpenerTS,Clicker,ClickerIP,ClickerTS,country_short,keywords) SELECT tblmaster_old.custid,tblmaster_old.email,crc32(md5(tblmaster_old.email)),tblmaster_old.firstname, tblmaster_old.middlename, tblmaster_old.lastname, tblmaster_old.address, tblmaster_old.address2, tblmaster_old.city, tblmaster_old.county, tblmaster_old.region, tblmaster_old.zipcode, tblmaster_old.gender, tblmaster_old.companyname, tblmaster_old.jobtitle, tblmaster_old.industry,tblmaster_old.phonearea,tblmaster_old.phonenum,tblmaster_old.born,tblmaster_old.source,tblmaster_old.dtTimeStamp,tblmaster_old.dateadded,tblmaster_old.ip,tblmaster_old.domain,tblmaster_old.exclude,tblmaster_old.Confirmed,tblmaster_old.ConfirmedIP,tblmaster_old.ConfirmedTS,tblmaster_old.Opener,tblmaster_old.OpenerIP,tblmaster_old.OpenerTS,tblmaster_old.Clicker,tblmaster_old.ClickerIP,tblmaster_old.ClickerTS,tblmaster_old.country_short, tblmaster_old.keywords FROM tblmaster_old   
ON DUPLICATE KEY UPDATE 
tblmaster.firstname = IF(tblmaster.firstname = '', tblmaster_old.firstname,  IF(tblmaster_old.firstname <> '', tblmaster_old.firstname, tblmaster.firstname)), 
tblmaster.lastname = IF(tblmaster.lastname = '', tblmaster_old.lastname, IF(tblmaster_old.lastname <>'', tblmaster_old.lastname, tblmaster.lastname)), 
tblmaster.address = IF(tblmaster.address = '', tblmaster_old.address, IF(tblmaster_old.address <> '', tblmaster_old.address, tblmaster.address)), 
tblmaster.address2 = IF(tblmaster.address2 = '', tblmaster_old.address2, IF(tblmaster_old.address2 <> '', tblmaster_old.address2, tblmaster.address2)), 
tblmaster.city = IF(tblmaster.city = '', tblmaster_old.city, IF(tblmaster_old.city <> '', tblmaster_old.city, tblmaster.city)), 
tblmaster.county = IF(tblmaster.county = '', tblmaster_old.county, IF(tblmaster_old.county <> '', tblmaster_old.county, tblmaster.county)), 
tblmaster.region = IF(tblmaster.region = '' , tblmaster_old.region, IF(tblmaster_old.region <>'', tblmaster_old.region, tblmaster.region)), 
tblmaster.zipcode = IF(tblmaster.zipcode = '', tblmaster_old.zipcode, IF(tblmaster_old.zipcode <> '', tblmaster_old.zipcode, tblmaster.zipcode)), 
tblmaster.gender = IF(tblmaster.gender = '', tblmaster_old.gender,  tblmaster.gender), 
tblmaster.companyname = IF(tblmaster.companyname = '', tblmaster_old.companyname, IF(tblmaster_old.companyname <> '', CONCAT(tblmaster_old.companyname,' ', tblmaster.companyname), tblmaster.companyname)), 
tblmaster.jobtitle = IF(tblmaster.jobtitle = '', tblmaster_old.jobtitle, IF(tblmaster_old.jobtitle <> '',  CONCAT(tblmaster.jobtitle, ' ', tblmaster_old.jobtitle), tblmaster.jobtitle)), 
tblmaster.industry = IF(tblmaster.industry = '',  tblmaster_old.industry, IF(tblmaster_old.industry <> '', CONCAT(tblmaster.industry,' ', tblmaster_old.industry), tblmaster.industry)), 
tblmaster.phonearea = IF(tblmaster.phonearea = '', tblmaster_old.phonearea, tblmaster.phonearea ), 
tblmaster.phonenum = IF(tblmaster.phonenum = '', tblmaster_old.phonenum, tblmaster.phonenum ), 
tblmaster.born = IF(tblmaster.born = 0000-00-00, tblmaster_old.born, tblmaster.born ), 
tblmaster.source = IF(tblmaster.source = '', tblmaster_old.source, tblmaster.source ), 
tblmaster.dtTimeStamp = IF(tblmaster.dtTimeStamp = '0000-00-00 00:00:00', tblmaster_old.dtTimeStamp, tblmaster.dtTimeStamp), 
tblmaster.dateadded = IF(tblmaster.dateadded = '0000-00-00', tblmaster_old.dateadded, tblmaster.dateadded ), 
tblmaster.ip = IF(tblmaster.ip = 0, tblmaster_old.ip, tblmaster.ip), 
tblmaster.keywords = IF(tblmaster.keywords = '', tblmaster_old.keywords, IF(tblmaster_old.keywords <> '', CONCAT(tblmaster.keywords,' ',tblmaster_old.keywords), tblmaster.keywords)) 
 ;



INSERT DELAYED IGNORE INTO tblmaster (custid,email,email_hash,firstname, middlename,lastname,address,address2,city,county,region,zipcode,gender,companyname,jobtitle,industry,phonearea,phonenum,born,source,dtTimeStamp,dateadded,ip,domain,exclude,Confirmed,ConfirmedIP,ConfirmedTS,Opener,OpenerIP,OpenerTS,Clicker,ClickerIP,ClickerTS,country_short,keywords) SELECT tblmaster_old.custid,tblmaster_old.email,crc32(md5(tblmaster_old.email)),tblmaster_old.firstname, tblmaster_old.middlename, tblmaster_old.lastname, tblmaster_old.address, tblmaster_old.address2, tblmaster_old.city, tblmaster_old.county, tblmaster_old.region, tblmaster_old.zipcode, tblmaster_old.gender, tblmaster_old.companyname, tblmaster_old.jobtitle, tblmaster_old.industry,tblmaster_old.phonearea,tblmaster_old.phonenum,tblmaster_old.born,tblmaster_old.source,tblmaster_old.dtTimeStamp,tblmaster_old.dateadded,tblmaster_old.ip,tblmaster_old.domain,tblmaster_old.exclude,tblmaster_old.Confirmed,tblmaster_old.ConfirmedIP,tblmaster_old.ConfirmedTS,tblmaster_old.Opener,tblmaster_old.OpenerIP,tblmaster_old.OpenerTS,tblmaster_old.Clicker,tblmaster_old.ClickerIP,tblmaster_old.ClickerTS,tblmaster_old.country_short, tblmaster_old.keywords FROM tblmaster_old   ;

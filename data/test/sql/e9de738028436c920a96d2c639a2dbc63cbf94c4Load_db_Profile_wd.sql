PRINT "========================" 
SELECT GETDATE()

LOAD DATABASE Profile_wd FROM '/data/dump/Profile_wd/Profile_wd-dba-1'
STRIPE ON '/data/dump/Profile_wd/Profile_wd-dba-2'
STRIPE ON '/data/dump/Profile_wd/Profile_wd-dba-3'
STRIPE ON '/data/dump/Profile_wd/Profile_wd-dba-4'
STRIPE ON '/data/dump/Profile_wd/Profile_wd-dba-5'
STRIPE ON '/data/dump/Profile_wd/Profile_wd-dba-6'
STRIPE ON '/data/dump/Profile_wd/Profile_wd-dba-7'
STRIPE ON '/data/dump/Profile_wd/Profile_wd-dba-8'
go

SELECT GETDATE()
PRINT "========================" 
go

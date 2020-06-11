PRINT "========================" 
SELECT GETDATE()

LOAD DATABASE Profile_md FROM '/data/dump/Profile_md/Profile_md-dba-1'
STRIPE ON '/data/dump/Profile_md/Profile_md-dba-2'
STRIPE ON '/data/dump/Profile_md/Profile_md-dba-3'
STRIPE ON '/data/dump/Profile_md/Profile_md-dba-4'
STRIPE ON '/data/dump/Profile_md/Profile_md-dba-5'
STRIPE ON '/data/dump/Profile_md/Profile_md-dba-6'
STRIPE ON '/data/dump/Profile_md/Profile_md-dba-7'
STRIPE ON '/data/dump/Profile_md/Profile_md-dba-8'
go

SELECT GETDATE()
PRINT "========================" 
go

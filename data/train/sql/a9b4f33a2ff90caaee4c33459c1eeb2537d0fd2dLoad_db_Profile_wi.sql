PRINT "========================" 
SELECT GETDATE()

LOAD DATABASE Profile_wi FROM '/data/dump/Profile_wi/Profile_wi-dba-1'
STRIPE ON '/data/dump/Profile_wi/Profile_wi-dba-2'
STRIPE ON '/data/dump/Profile_wi/Profile_wi-dba-3'
STRIPE ON '/data/dump/Profile_wi/Profile_wi-dba-4'
STRIPE ON '/data/dump/Profile_wi/Profile_wi-dba-5'
STRIPE ON '/data/dump/Profile_wi/Profile_wi-dba-6'
STRIPE ON '/data/dump/Profile_wi/Profile_wi-dba-7'
STRIPE ON '/data/dump/Profile_wi/Profile_wi-dba-8'
go

SELECT GETDATE()
PRINT "========================" 
go

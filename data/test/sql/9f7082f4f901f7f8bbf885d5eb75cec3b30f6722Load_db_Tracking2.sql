PRINT "========================" 
SELECT GETDATE()

LOAD DATABASE Tracking2 FROM '/data/dump/Tracking2/Tracking2-dba-1'
STRIPE ON '/data/dump/Tracking2/Tracking2-dba-2'
STRIPE ON '/data/dump/Tracking2/Tracking2-dba-3'
STRIPE ON '/data/dump/Tracking2/Tracking2-dba-4'
STRIPE ON '/data/dump/Tracking2/Tracking2-dba-5'
STRIPE ON '/data/dump/Tracking2/Tracking2-dba-6'
STRIPE ON '/data/dump/Tracking2/Tracking2-dba-7'
STRIPE ON '/data/dump/Tracking2/Tracking2-dba-8'
go

SELECT GETDATE()
PRINT "========================" 
go

PRINT "========================" 
SELECT GETDATE()

LOAD DATABASE Tracking1 FROM '/data/dump/Tracking1/Tracking1-dba-1'
STRIPE ON '/data/dump/Tracking1/Tracking1-dba-2'
STRIPE ON '/data/dump/Tracking1/Tracking1-dba-3'
STRIPE ON '/data/dump/Tracking1/Tracking1-dba-4'
STRIPE ON '/data/dump/Tracking1/Tracking1-dba-5'
STRIPE ON '/data/dump/Tracking1/Tracking1-dba-6'
STRIPE ON '/data/dump/Tracking1/Tracking1-dba-7'
STRIPE ON '/data/dump/Tracking1/Tracking1-dba-8'
go

SELECT GETDATE()
PRINT "========================" 
go

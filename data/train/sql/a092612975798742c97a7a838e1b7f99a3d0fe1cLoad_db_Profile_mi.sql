PRINT "========================" 
SELECT GETDATE()

LOAD DATABASE Profile_mi FROM '/data/dump/Profile_mi/Profile_mi-dba-1'
STRIPE ON '/data/dump/Profile_mi/Profile_mi-dba-2'
STRIPE ON '/data/dump/Profile_mi/Profile_mi-dba-3'
STRIPE ON '/data/dump/Profile_mi/Profile_mi-dba-4'
STRIPE ON '/data/dump/Profile_mi/Profile_mi-dba-5'
STRIPE ON '/data/dump/Profile_mi/Profile_mi-dba-6'
STRIPE ON '/data/dump/Profile_mi/Profile_mi-dba-7'
STRIPE ON '/data/dump/Profile_mi/Profile_mi-dba-8'
go

SELECT GETDATE()
PRINT "========================" 
go

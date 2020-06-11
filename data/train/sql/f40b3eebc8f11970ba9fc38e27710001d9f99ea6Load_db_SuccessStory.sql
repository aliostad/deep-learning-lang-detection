PRINT "========================" 
SELECT GETDATE()

LOAD DATABASE SuccessStory FROM '/data/dump/SuccessStory/SuccessStory-dba-1'
STRIPE ON '/data/dump/SuccessStory/SuccessStory-dba-2'
STRIPE ON '/data/dump/SuccessStory/SuccessStory-dba-3'
STRIPE ON '/data/dump/SuccessStory/SuccessStory-dba-4'
STRIPE ON '/data/dump/SuccessStory/SuccessStory-dba-5'
STRIPE ON '/data/dump/SuccessStory/SuccessStory-dba-6'
STRIPE ON '/data/dump/SuccessStory/SuccessStory-dba-7'
STRIPE ON '/data/dump/SuccessStory/SuccessStory-dba-8'
go

SELECT GETDATE()
PRINT "========================" 
go

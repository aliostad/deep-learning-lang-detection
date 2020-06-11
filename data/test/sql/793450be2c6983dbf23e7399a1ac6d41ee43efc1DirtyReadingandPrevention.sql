/* 

Data dirty reading: consistency and locking
Helpful article: http://blog.sqlauthority.com/2012/11/15/sql-server-concurrency-basics-guest-post-by-vinod-kumar/ by Vinod Kumar

*/

-- Pessimistic concurrency - frequent blocking, increased consistency
-- Optimistic concurrency - little blocking, decreased consistency


SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;

SET TRANSACTION ISOLATION LEVEL SNAPSHOT;

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;


-- Helpful information table
DECLARE @dirty TABLE(
	[Details] VARCHAR(50),
	[Read Uncommitted] VARCHAR(50),
	[Read Committed] VARCHAR(50),
	[Repeatable Read] VARCHAR(50),
	[Snapshot] VARCHAR(50),
	[Serializable] VARCHAR(50)
)

INSERT INTO @dirty VALUES ('ISOLATION LEVEL:','Optimistic','Both','Pessimistic','Optimistic','Pessimistic')
INSERT INTO @dirty VALUES ('BEHAVIOR - DIRTY READS:','Yes','No','No','Yes','No')

SELECT * FROM @dirty
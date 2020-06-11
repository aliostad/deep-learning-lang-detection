SET STATISTICS IO ON

SELECT U.DisplayName, Title, MostRecentPost.CreationDate FROM Users U JOIN (
	SELECT Id, OwnerUserId, Title, CreationDate FROM Posts P WHERE P.Id IN 
		(SELECT MAX(Id) FROM Posts GROUP BY OwnerUserId)
	) AS MostRecentPost
ON U.Id = MostRecentPost.OwnerUserId;

/*
(1348330 row(s) affected)
Table 'Worktable'. Scan count 0, logical reads 0, physical reads 0, read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.
Table 'Workfile'. Scan count 24, logical reads 1344, physical reads 96, read-ahead reads 1248, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.
Table 'Posts'. Scan count 18, logical reads 343214, physical reads 0, read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.
Table 'Users'. Scan count 0, logical reads 4130015, physical reads 15, read-ahead reads 108, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.
Table 'Worktable'. Scan count 0, logical reads 0, physical reads 0, read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.
*/

CREATE VIEW vwPostsByUser WITH SCHEMABINDING AS
SELECT U.DisplayName, Title, MostRecentPost.CreationDate FROM dbo.Users U JOIN (
	SELECT Id, OwnerUserId, Title, CreationDate FROM dbo.Posts P WHERE P.Id IN 
		(SELECT MAX(Id) FROM dbo.Posts GROUP BY OwnerUserId)
	) AS MostRecentPost
ON U.Id = MostRecentPost.OwnerUserId;


SELECT * FROM vwPostsByUser ;
/*
(1348330 row(s) affected)
Table 'Worktable'. Scan count 0, logical reads 0, physical reads 0, read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.
Table 'Workfile'. Scan count 24, logical reads 1344, physical reads 96, read-ahead reads 1248, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.
Table 'Posts'. Scan count 18, logical reads 343246, physical reads 0, read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.
Table 'Users'. Scan count 0, logical reads 4129343, physical reads 0, read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.
Table 'Worktable'. Scan count 0, logical reads 0, physical reads 0, read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.

*/

CREATE UNIQUE CLUSTERED INDEX IX_vwPostsByUser
	ON vwPostsByUser(DisplayName, Title, CreationDate)
/*
Table 'Users'. Scan count 9, logical reads 31713, physical reads 0, read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.
Table 'Posts'. Scan count 9, logical reads 171164, physical reads 0, read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.
Table 'Workfile'. Scan count 0, logical reads 0, physical reads 0, read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.
Table 'Worktable'. Scan count 0, logical reads 0, physical reads 0, read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.
*/

SELECT * FROM vwPostsByUser;
/*
(5578880 row(s) affected)
Table 'vwPostsByUser'. Scan count 1, logical reads 100745, physical reads 0, read-ahead reads 4, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.
*/


SELECT U.DisplayName, P.Title, P.CreationDate  FROM Posts P
INNER JOIN Users U ON U.Id = P.OwnerUserId
WHERE P.Title IS NOT NULL;
/*
The optimizer will use the indexed view to complete the original query now
(5578880 row(s) affected)
Table 'vwPostsByUser'. Scan count 1, logical reads 100745, physical reads 0, read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.
*/

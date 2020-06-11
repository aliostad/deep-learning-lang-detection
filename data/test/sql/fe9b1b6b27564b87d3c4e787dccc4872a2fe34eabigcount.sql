SET NOCOUNT ON
SET STATISTICS IO ON
SET STATISTICS TIME ON

PRINT 'On your marks.
Get set.

GO!'

-- Note AColumn holds NO NULLS /*   SELECT COUNT_BIG(AColumn) FROM VeryBigTable WHERE AColumn IS NULL   */
SELECT COUNT_BIG(AColumn)
FROM VeryBigTable

PRINT '= = = = = = = = = ='

SELECT COUNT_BIG(*)
FROM VeryBigTable

SET STATISTICS IO OFF
SET STATISTICS TIME OFF
SET NOCOUNT OFF

/*
-- Experiment one:

On your marks.
Get set.

GO!

 SQL Server Execution Times:
   CPU time = 0 ms,  elapsed time = 0 ms.
Table 'VeryBigTable'. Scan count 33, logical reads 1928697, physical reads 0, read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.

 SQL Server Execution Times:
   CPU time = 3631 ms,  elapsed time = 2874 ms.
= = = = = = = = = =

 SQL Server Execution Times:
   CPU time = 0 ms,  elapsed time = 0 ms.
Table 'VeryBigTable'. Scan count 33, logical reads 1928697, physical reads 0, read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.

 SQL Server Execution Times:
   CPU time = 3761 ms,  elapsed time = 1476 ms.

 SQL Server Execution Times:
   CPU time = 0 ms,  elapsed time = 0 ms.

-- Experiment two:

On your marks.
Get set.

GO!

 SQL Server Execution Times:
   CPU time = 0 ms,  elapsed time = 0 ms.
Table 'VeryBigTable'. Scan count 33, logical reads 1928697, physical reads 0, read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.

 SQL Server Execution Times:
   CPU time = 5178 ms,  elapsed time = 1108 ms.
= = = = = = = = = =

 SQL Server Execution Times:
   CPU time = 0 ms,  elapsed time = 0 ms.
Table 'VeryBigTable'. Scan count 33, logical reads 1928697, physical reads 0, read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.

 SQL Server Execution Times:
   CPU time = 4167 ms,  elapsed time = 1144 ms.

 SQL Server Execution Times:
   CPU time = 0 ms,  elapsed time = 0 ms.


-- Experiment three:

On your marks.
Get set.

GO!

 SQL Server Execution Times:
   CPU time = 0 ms,  elapsed time = 0 ms.
Table 'VeryBigTable'. Scan count 33, logical reads 1928697, physical reads 0, read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.

 SQL Server Execution Times:
   CPU time = 3775 ms,  elapsed time = 3131 ms.
= = = = = = = = = =

 SQL Server Execution Times:
   CPU time = 0 ms,  elapsed time = 0 ms.
Table 'VeryBigTable'. Scan count 33, logical reads 1928697, physical reads 0, read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.

 SQL Server Execution Times:
   CPU time = 2325 ms,  elapsed time = 2979 ms.

 SQL Server Execution Times:
   CPU time = 0 ms,  elapsed time = 0 ms.

*/

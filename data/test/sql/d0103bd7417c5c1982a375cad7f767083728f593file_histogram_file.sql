col filename format a100 heading "FileName"
col read_time format a9 heading "Read Time|(ms)"
col reads format 99,999,999 heading "Reads"
col histogram format a51 heading ""

SELECT LAG(fh.singleblkrdtim_milli, 1) 
         OVER (ORDER BY fh.singleblkrdtim_milli) 
          || '<' || fh.singleblkrdtim_milli read_time, 
       SUM(fh.singleblkrds) reads,
       RPAD(' ', ROUND(SUM(fh.singleblkrds) * 50 / 
         MAX(SUM(fh.singleblkrds)) OVER ()), '*')  histogram
FROM v$file_histogram fh
	inner join v$datafile df
		on df.file# = fh.file#
	inner join ts
		on ts.ts# = df.ts#
where df.name like '&file'
and ts.name like '&tsname'
GROUP BY  fh.singleblkrdtim_milli
ORDER BY  fh.singleblkrdtim_milli; 
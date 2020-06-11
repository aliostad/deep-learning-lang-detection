/*
三角数の数列は自然数の和で表わされ, 7番目の三角数は 1 + 2 + 3 + 4 + 5 + 6 + 7 = 28 である. 三角数の最初の10項は:
1, 3, 6, 10, 15, 21, 28, 36, 45, 55, ...
となる.
最初の7項について, その約数を列挙すると, 以下のとおり.
 1: 1
 3: 1,3
 6: 1,2,3,6
10: 1,2,5,10
15: 1,3,5,15
21: 1,3,7,21
28: 1,2,4,7,14,28
これから, 7番目の三角数である28は, 6個以上の約数をもつ最初の三角数であることが分かる.
では, 500個以上の約数をもつ最初の三角数はいくつか.
http://odz.sakura.ne.jp/projecteuler/index.php?cmd=read&page=Problem%2012
*/
WITH RECURSIVE temp(n,list) AS (
SELECT 1,[1]
UNION ALL
SELECT
  (CASE n WHEN 1 THEN 3 ELSE
    (CASE n+)
  END)
  , (CASE n WHEN 1 THEN [1,3] ELSE
    ARRAY(SELECT generate_series FROM(SELECT generate_series(1,10)) a WHERE generate_series%3=0)
  END)
)


WITH RECURSIVE temp(n,z,prime,list,e) AS (
SELECT
  1
  , 1
  , 2
  , ARRAY[1]::int[]
  , 1::double precision
UNION ALL
SELECT
  (CASE n WHEN 1 THEN 2 ELSE (CASE z WHEN 1 THEN n+1 ELSE n END) END)
  , (CASE z WHEN 1 THEN n+1 ELSE
      (CASE WHEN z%prime=0 THEN z/prime ELSE z END)
    END)
  , (CASE z WHEN 1 THEN 2 ELSE
      (CASE WHEN z%prime=0
        THEN prime
        ELSE (CASE prime WHEN 2 THEN 3 ELSE prime+2 END)
      END)
    END)
  , (CASE z WHEN 1 THEN ARRAY[]::int[] ELSE
      (CASE WHEN z%prime=0
        THEN array_append(list,prime)
        ELSE list
      END)
    END)
  , (CASE WHEN z%prime=0 THEN
      (CASE WHEN z/prime = 1 THEN
        (SELECT exp(SUM(e))
        FROM
          (SELECT unnest, ln(COUNT(*)+1) e
            FROM (SELECT unnest(array_append(list,prime))) b
            GROUP BY unnest) c)
      ELSE 0 END)
    ELSE 0 END)
FROM temp t
WHERE n < 10
)
SELECT *
FROM temp
WHERE z = 1

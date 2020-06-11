select CAR_YEAR, MODEL, COUNT(*)
from car_model
GROUP BY CAR_YEAR, MODEL


SELECT CAR_YEAR
      ,SUM(아반테) 아반테
      ,SUM(그랜저) 그랜저
      ,SUM(액센트) 액센트
      ,SUM(체어맨) 체어맨
      ,SUM(소렌토) 소렌토
      ,SUM(SM3)  SM3
      ,SUM(QM5)  QM5
FROM (      
	SELECT CAR_YEAR
	      ,SUM(DECODE(MODEL, '아반테', 1, 0)) 아반테
	      ,SUM(DECODE(MODEL, '그랜저', 1, 0)) 그랜저
	      ,SUM(DECODE(MODEL, '체어맨', 1, 0)) 체어맨
	      ,SUM(DECODE(MODEL, '소렌토', 1, 0)) 소렌토
	      ,SUM(DECODE(MODEL, '액센트', 1, 0)) 액센트
	      ,SUM(DECODE(MODEL, 'SM3' , 1, 0)) SM3
	      ,SUM(DECODE(MODEL, 'QM5' , 1, 0)) QM5
	FROM CAR_MODEL	
    GROUP BY CAR_YEAR
 ) A
 GROUP BY CAR_YEAR 
 ORDER BY CAR_YEAR DESC
 
 -- 11g
 SELECT * FROM (
     SELECT CAR_YEAR, MODEL
     FROM CAR_MODEL
 ) PIVOT (
     COUNT(MODEL)
     FOR MODEL IN ('아반테', '그랜저', '체어맨', '소렌토', '액센트', 'SM3', 'QM5')
 ) A
 ORDER BY CAR_YEAR DESC
 
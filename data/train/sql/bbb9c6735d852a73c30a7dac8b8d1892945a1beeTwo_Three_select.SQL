select * from(select row_number() over(
ORDER BY b.xn,b.xq, b.kh
)as row,b.* from(SELECT DISTINCT L_VIEW_CLASS_FX.YEAR AS xn,L_VIEW_CLASS_FX.TERM AS xq,
      L_view_class_fx.courseno + L_view_class_fx.[group] kh, ls_km.km AS km,
      ls_xkrs.xkrs AS xkrs, ls.yxrs yxrs, ls_lhrs.lhrs AS lhrs,
      ls_zdrs.zdrs AS zdrs, ls_jgrs.jgrs AS jgrs, ls_bjgrs.bjgrs AS bjg,
      ls_qkrs.qkrs AS qkrs
FROM L_view_class_fx

LEFT OUTER JOIN
          (SELECT courses.courseno AS kh, courses.coursename km
         FROM courses) AS ls_km ON L_view_class_fx.courseno = ls_km.kh

LEFT OUTER JOIN
          (SELECT L_view_class_fx.YEAR,L_view_class_fx.TERM, L_view_class_fx.courseno + L_view_class_fx.[group] xx, COUNT(L_view_class_fx.courseno)
               AS xkrs
         FROM L_view_class_fx
	WHERE L_view_class_fx.classno=:CONE and L_view_class_fx.year=:YONE AND
L_view_class_fx.TERM=:TONE
         GROUP BY L_view_class_fx.classno, L_view_class_fx.YEAR,L_view_class_fx.TERM,  L_view_class_fx.courseno + L_view_class_fx.[group]) AS Ls_xkrs
ON L_view_class_fx.YEAR=ls_xkrs.year and L_view_class_fx.term=ls_xkrs.term and L_view_class_fx.courseno + L_view_class_fx.[group] = ls_xkrs.xx

LEFT OUTER JOIN
          (SELECT L_view_class_fx.YEAR,L_view_class_fx.TERM, L_view_class_fx.courseno + L_view_class_fx.[group] xx, COUNT(L_view_class_fx.courseno)
               AS yxrs
         FROM L_view_class_fx
         WHERE L_view_class_fx.classno=:CTWO   and L_view_class_fx.year=:YTWO AND
L_view_class_fx.TERM=:TTWO  and
               (L_view_class_fx.testscore = '优秀' OR
               L_view_class_fx.examscore >= 90)
         GROUP BY L_view_class_fx.classno,L_view_class_fx.YEAR,L_view_class_fx.TERM, L_view_class_fx.courseno + L_view_class_fx.[group]) AS ls
ON  L_view_class_fx.YEAR=ls.year and L_view_class_fx.term=ls.term and
      L_view_class_fx.courseno + L_view_class_fx.[group] = ls.xx

 LEFT OUTER JOIN
          (SELECT L_view_class_fx.YEAR,L_view_class_fx.TERM, L_view_class_fx.courseno + L_view_class_fx.[group] xx, COUNT(L_view_class_fx.courseno)
               AS lhrs
         FROM L_view_class_fx
         WHERE L_view_class_fx.classno=:CTHREE  and L_view_class_fx.year=:YTHREE AND
L_view_class_fx.TERM=:TTHREE  and (L_view_class_fx.testscore = '良好' OR
               (L_view_class_fx.examscore >= 80 AND L_view_class_fx.examscore < 90))
         GROUP BY L_view_class_fx.classno,L_view_class_fx.YEAR,L_view_class_fx.TERM, L_view_class_fx.courseno + L_view_class_fx.[group]) AS ls_lhrs ON
      L_view_class_fx.courseno + L_view_class_fx.[group] = ls_lhrs.xx

LEFT OUTER JOIN
          (SELECT L_view_class_fx.YEAR,L_view_class_fx.TERM, L_view_class_fx.courseno + L_view_class_fx.[group] xx, COUNT(L_view_class_fx.courseno)
               AS zdrs
         FROM L_view_class_fx
         WHERE L_view_class_fx.classno=:CFOUR  and L_view_class_fx.year=:YFOUR AND
L_view_class_fx.TERM=:TFOUR  and  (L_view_class_fx.testscore = '中等' OR
               (L_view_class_fx.examscore >= 70 AND L_view_class_fx.examscore < 80))
         GROUP BY L_view_class_fx.classno,L_view_class_fx.YEAR,L_view_class_fx.TERM, L_view_class_fx.courseno + L_view_class_fx.[group]) AS ls_zdrs ON
      L_view_class_fx.courseno + L_view_class_fx.[group] = ls_zdrs.xx

LEFT OUTER JOIN
          (SELECT L_view_class_fx.YEAR,L_view_class_fx.TERM, L_view_class_fx.courseno + L_view_class_fx.[group] xx, COUNT(L_view_class_fx.courseno)
               AS jgrs
         FROM L_view_class_fx
         WHERE L_view_class_fx.classno=:CFIVE  and L_view_class_fx.year=:YFIVE AND
L_view_class_fx.TERM=:TFIVE  and (L_view_class_fx.testscore = '及格' OR
               L_view_class_fx.testscore = '合格' OR
               (L_view_class_fx.examscore >= 60 AND L_view_class_fx.examscore < 70))
         GROUP BY L_view_class_fx.classno, L_view_class_fx.YEAR,L_view_class_fx.TERM, L_view_class_fx.courseno + L_view_class_fx.[group]) AS ls_jgrs ON
      L_view_class_fx.courseno + L_view_class_fx.[group] = ls_jgrs.xx

 LEFT OUTER JOIN
          (SELECT L_view_class_fx.YEAR,L_view_class_fx.TERM, L_view_class_fx.courseno + L_view_class_fx.[group] xx, COUNT(L_view_class_fx.courseno)
               AS bjgrs
         FROM L_view_class_fx
         WHERE  L_view_class_fx.classno=:CSIX  and L_view_class_fx.year=:YSIX AND
L_view_class_fx.TERM=:TSIX  and
               ((L_view_class_fx.testscore = '不及格' OR
               L_view_class_fx.testscore = '不合格' OR
               L_view_class_fx.testscore = '作弊') OR
               (L_view_class_fx.examscore > 0 AND L_view_class_fx.examscore < 60) OR
               (L_view_class_fx.examscore = 0 AND L_view_class_fx.testscore = ''))
         GROUP BY L_view_class_fx.classno, L_view_class_fx.YEAR,L_view_class_fx.TERM, L_view_class_fx.courseno + L_view_class_fx.[group]) AS ls_bjgrs ON
      L_view_class_fx.courseno + L_view_class_fx.[group] = ls_bjgrs.xx

 LEFT OUTER JOIN
          (SELECT L_view_class_fx.YEAR,L_view_class_fx.TERM, L_view_class_fx.courseno + L_view_class_fx.[group] xx, COUNT(L_view_class_fx.courseno)
               AS qkrs
         FROM L_view_class_fx
         WHERE L_view_class_fx.classno=:CSEVEN  and L_view_class_fx.year=:YSEVEN AND
L_view_class_fx.TERM=:TSEVEN  and
L_view_class_fx.testscore = '缺考'
         GROUP BY L_view_class_fx.classno, L_view_class_fx.YEAR,L_view_class_fx.TERM, L_view_class_fx.courseno + L_view_class_fx.[group]) AS ls_qkrs ON
      L_view_class_fx.courseno + L_view_class_fx.[group] = ls_qkrs.xx

WHERE L_view_class_fx.classno=:CEIGHT  and L_view_class_fx.year=:YEIGHT AND
L_view_class_fx.TERM=:TEIGHT
) as b )as c


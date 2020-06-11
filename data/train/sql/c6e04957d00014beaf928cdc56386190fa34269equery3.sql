select count(*) from (
SELECT distinct sesso, stanza, codice_letto
 FROM REGINA_LOGISTICA_V 
 WHERE 1=1
AND gmadal <=  cast('2012-02-16' as date) 
AND (gmaal is null or (gmaal >= cast('2012-02-16' as date))) 
AND codice_letto IN ( 35, 36, 33, 34, 39, 37, 192, 38, 43, 42, 41, 40, 202, 67, 66, 69, 68, 22, 23, 24, 25, 26, 27, 28, 29, 3, 2, 1, 7, 30, 6, 5, 32, 4, 31, 9, 8, 59, 58, 57, 56, 19, 55, 17, 18, 15, 16, 13, 14, 11, 12, 21, 20, 64, 65, 62, 63, 60, 61, 49, 48, 45, 44, 47, 46, 10, 51, 52, 53, 54, 50 )
)

-- Good Query
select count(*) from (
Select a.codospite,a.nomeospite,a.sesso,d.sede,d.reparto,d.stanza,d.codice_letto,t.descr 
from ospiti_a a join ospiti_d d on (a.codospite=d.codospite)
left join clin_medico_stanza m on (m.codstan=d.stanza and m.gmadal<=cast('2012-02-16' as date) and (m.gmaal is null or (m.gmaal>=cast('2012-02-16' as date))))
left join teanapers t on (t.progr=m.progmedico)
where a.gmaing<=cast('2012-02-16' as date) 
and (a.gmadim is null or (a.gmadim>cast('2012-02-16' as date) ))
and d.gmainizioutili<=cast('2012-02-16' as date) 
and ((d.gmafineutili>cast('2012-02-16' as date)) or d.gmafineutili is null)
and d.codice_letto IN ( 35, 36, 33, 34, 39, 37, 192, 38, 43, 42, 41, 40, 202, 67, 66, 69, 68, 22, 23, 24, 25, 26, 27, 28, 29, 3, 2, 1, 7, 30, 6, 5, 32, 4, 31, 9, 8, 59, 58, 57, 56, 19, 55, 17, 18, 15, 16, 13, 14, 11, 12, 21, 20, 64, 65, 62, 63, 60, 61, 49, 48, 45, 44, 47, 46, 10, 51, 52, 53, 54, 50 )
)


sbQuery.append("select a.codospite,a.nomeospite,a.sesso,d.sede,d.reparto,d.stanza,d.codice_letto,t.descr  ");
sbQuery.append("from ospiti_a a join ospiti_d d on (a.codospite=d.codospite)  ");
sbQuery.append("left join clin_medico_stanza m on (m.codstan=d.stanza and m.gmadal<=? and (m.gmaal is null or (m.gmaal>=?)))  ");
sbQuery.append("left join teanapers t on (t.progr=m.progmedico)  ");
sbQuery.append("where a.gmaing<=?  ");
sbQuery.append("and (a.gmadim is null or (a.gmadim>?))  ");
sbQuery.append("and d.gmainizioutili<=?  ");
sbQuery.append("and ((d.gmafineutili>?) or d.gmafineutili is null)  ");
sbQuery.append("and d.codice_letto IN (?)  ");

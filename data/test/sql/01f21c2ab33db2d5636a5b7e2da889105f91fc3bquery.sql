--查询本日各etf的最低溢价率
SELECT *
FROM hedger.etf_detail
WHERE DATE(updateTime) = CURDATE()
  AND volume > 500
GROUP BY fund_id HAVING min(discount_rt)
ORDER BY discount_rt,
         updateTime DESC;

 --查询本日各etf的最高溢价率
SELECT *
FROM hedger.etf_detail
WHERE DATE(updateTime) = CURDATE()
  AND volume > 500
GROUP BY fund_id HAVING max(discount_rt)
ORDER BY discount_rt DESC, updateTime DESC;

 --查询前一个交易日成交量超过千万的etf
SELECT DISTINCT fund_id
FROM hedger.etf_detail
WHERE DATE(nav_datetime)=
    (SELECT DATE(nav_datetime) AS lastTradeDay
     FROM hedger.etf_detail
     WHERE DATE(nav_datetime)<CURDATE()-1
     ORDER BY updateTime DESC LIMIT 1)
  AND volume>1000;
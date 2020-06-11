-- dynamic partitions
CREATE TABLE taobao_com_page_view LIKE page_view;
--ALTER TABLE taobao_com_page_view ADD PARTITION (dt='2011-12-17', country='China');
INSERT OVERWRITE TABLE taobao_com_page_view PARTITION(dt,country)
SELECT page_view.*
FROM page_view
WHERE page_view.dt='2011-12-17' AND
      page_view.referrer_url LIKE '%taobao.com/';

INSERT OVERWRITE TABLE from_taobao_with_partition 
       PARTITION(dt='2011-12-17',country)
SELECT pv.user_id, pv.view_time, pv.page_url, pv.referrer_url, pv.ip, pv.country
FROM page_view pv
WHERE pv.dt='2011-12-17' AND
      pv.referrer_url LIKE '%taobao.com/';


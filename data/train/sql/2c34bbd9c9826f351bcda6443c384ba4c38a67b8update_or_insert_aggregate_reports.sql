DELIMITER ;;
DROP PROCEDURE if exists update_or_insert_aggregate_reports;
CREATE PROCEDURE update_or_insert_aggregate_reports(IN entity_class_2_entity_id VARCHAR(255), IN new_year INTEGER, IN new_month INTEGER, IN new_date INTEGER, IN new_hour INTEGER, IN new_views INTEGER, IN new_clicks INTEGER)
BEGIN
  INSERT INTO aggregate_reports (entity_key, ts_year, ts_month, ts_date, ts_hour, views, clicks) VALUES (
    entity_class_2_entity_id, new_year, new_month, new_date, new_hour, new_views, new_clicks
    )
  ON DUPLICATE KEY UPDATE
    views = views + new_views, clicks = clicks + new_clicks;
END
;;
delimiter ;

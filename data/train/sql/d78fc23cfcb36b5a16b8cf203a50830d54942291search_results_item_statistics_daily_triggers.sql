DROP TRIGGER IF EXISTS `search_results_item_statistics_daily_ai` $$
CREATE TRIGGER search_results_item_statistics_daily_ai AFTER INSERT on `search_results_item_statistics_daily`
FOR EACH ROW
BEGIN
    -- update the count in consolidation table
    INSERT INTO `search_results_item_statistics_annual` (`date`, `category_id`, `institution_id`, `institution_medical_center_id`, `country_id`, `city_id`, `specialization_id`, `sub_specialization_id`, `treatment_id`, `total`) 
    VALUES (NEW.`date`, NEW.`category_id`, NEW.`institution_id`, NEW.`institution_medical_center_id`, NEW.`country_id`, NEW.`city_id`, NEW.`specialization_id`, NEW.`sub_specialization_id`, NEW.`treatment_id`, 1)
    ON DUPLICATE KEY  UPDATE total = total+1;
END; $$
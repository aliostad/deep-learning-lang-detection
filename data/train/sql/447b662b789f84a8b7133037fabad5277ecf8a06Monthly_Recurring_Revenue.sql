DELIMITER $$
DROP VIEW IF EXISTS `Coworks_In`.`viewMonthly_Recurring_Revenue`$$
CREATE VIEW `viewMonthly_Recurring_Revenue` AS SELECT `id`, `coworking_space_id`, `start_of_month_recurring_revenue`, `new_recurring_revenue_from_new_customers`, `new_recurring_revenue_from_expansion`, `total_new_recurring_revenue`, `lost_recurring_revenue_from_contraction`, `churn_rate`, `net_new_recurring_revenue`, `end_of_month_recurring_revenue`, `month_over_month_growth`, `average_revenue_per_account`, `average_revenue_per_new_account`, `create_date`, `modify_date` FROM `Monthly_Recurring_Revenue`$$
DELIMITER ;

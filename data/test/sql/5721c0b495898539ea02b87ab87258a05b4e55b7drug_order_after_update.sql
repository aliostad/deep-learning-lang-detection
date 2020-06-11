DELIMITER $$
DROP TRIGGER IF EXISTS `drug_order_after_update`$$
CREATE TRIGGER `drug_order_after_update` AFTER UPDATE 
ON `drug_order`
FOR EACH ROW
BEGIN

    SET @visit = (SELECT COALESCE((SELECT id FROM flat_table2 WHERE  
        (drug_order_id1 = new.order_id OR drug_order_id2 = new.order_id OR drug_order_id3 = new.order_id OR
        drug_order_id4 = new.order_id OR drug_order_id5 = new.order_id)), 0));
    
    SET @drug_set1 = (SELECT COALESCE(drug_order_id1, '') FROM flat_table2 WHERE ID = @visit AND drug_order_id1 = new.order_id);
    
    SET @drug_set2 = (SELECT COALESCE(drug_order_id2, '') FROM flat_table2 WHERE ID = @visit AND drug_order_id2 = new.order_id);
    
    SET @drug_set3 = (SELECT COALESCE(drug_order_id3, '') FROM flat_table2 WHERE ID = @visit AND drug_order_id3 = new.order_id);
    
    SET @drug_set4 = (SELECT COALESCE(drug_order_id4, '') FROM flat_table2 WHERE ID = @visit AND drug_order_id4 = new.order_id);
    
    SET @drug_set5 = (SELECT COALESCE(drug_order_id5, '') FROM flat_table2 WHERE ID = @visit AND drug_order_id5 = new.order_id);

    CASE 
        WHEN @drug_set1 != "" THEN
            
            SET @drug_name = (SELECT name FROM drug WHERE drug_id = new.drug_inventory_id LIMIT 1);
            
            SET @encounter_id = (SELECT encounter_id FROM orders WHERE order_id = new.order_id LIMIT 1);
               
            UPDATE flat_table2 SET drug_inventory_id1 = new.drug_inventory_id, drug_name1 = @drug_name, drug_equivalent_daily_dose1 = new.equivalent_daily_dose, drug_dose1 = new.dose, drug_frequency1 = new.frequency,drug_quantity1 = new.quantity, drug_quantity1_enc_id = @encounter_id WHERE flat_table2.id = @visit;
                
        WHEN @drug_set2 != "" THEN        
             
            SET @drug_name = (SELECT name FROM drug WHERE drug_id = new.drug_inventory_id LIMIT 1);
            
            SET @encounter_id = (SELECT encounter_id FROM orders WHERE order_id = new.order_id LIMIT 1);
               
            UPDATE flat_table2 SET drug_inventory_id2 = new.drug_inventory_id, drug_name2 = @drug_name, drug_equivalent_daily_dose2 = new.equivalent_daily_dose, drug_dose2 = new.dose, drug_frequency2 = new.frequency,drug_quantity2 = new.quantity, drug_quantity2_enc_id = @encounter_id WHERE flat_table2.id = @visit;
                
        WHEN @drug_set3 != "" THEN
         
            SET @drug_name = (SELECT name FROM drug WHERE drug_id = new.drug_inventory_id LIMIT 1);
            
            SET @encounter_id = (SELECT encounter_id FROM orders WHERE order_id = new.order_id LIMIT 1);
               
            UPDATE flat_table2 SET drug_inventory_id3 = new.drug_inventory_id, drug_name3 = @drug_name, drug_equivalent_daily_dose3 = new.equivalent_daily_dose, drug_dose3 = new.dose, drug_frequency3 = new.frequency,drug_quantity3 = new.quantity, drug_quantity3_enc_id = @encounter_id WHERE flat_table2.id = @visit;
                
        WHEN @drug_set4 != "" THEN
         
            SET @drug_name = (SELECT name FROM drug WHERE drug_id = new.drug_inventory_id LIMIT 1);
            
            SET @encounter_id = (SELECT encounter_id FROM orders WHERE order_id = new.order_id LIMIT 1);
               
            UPDATE flat_table2 SET drug_inventory_id4 = new.drug_inventory_id, drug_name4 = @drug_name, drug_equivalent_daily_dose4 = new.equivalent_daily_dose, drug_dose4 = new.dose, drug_frequency4 = new.frequency,drug_quantity4 = new.quantity, drug_quantity4_enc_id = @encounter_id WHERE flat_table2.id = @visit;
                
        WHEN @drug_set5 != "" THEN
         
            SET @drug_name = (SELECT name FROM drug WHERE drug_id = new.drug_inventory_id LIMIT 1);
            
            SET @encounter_id = (SELECT encounter_id FROM orders WHERE order_id = new.order_id LIMIT 1);
               
            UPDATE flat_table2 SET drug_inventory_id5 = new.drug_inventory_id, drug_name5 = @drug_name, drug_equivalent_daily_dose5 = new.equivalent_daily_dose, drug_dose5 = new.dose, drug_frequency5 = new.frequency,drug_quantity5 = new.quantity, drug_quantity5_enc_id = @encounter_id WHERE flat_table2.id = @visit;
                
        ELSE
        
           SET @visit = 0;                      
    
    END CASE;

END$$

DELIMITER ;

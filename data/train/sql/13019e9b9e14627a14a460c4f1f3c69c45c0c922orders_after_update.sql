DELIMITER $$
DROP TRIGGER IF EXISTS `orders_after_update`$$
CREATE TRIGGER `orders_after_update` AFTER UPDATE 
ON `orders`
FOR EACH ROW
BEGIN

    SET @patient_id = (SELECT patient_id FROM encounter WHERE encounter_id = new.encounter_id);

    SET @visit = (SELECT COALESCE((SELECT id FROM flat_table2 WHERE patient_id = @patient_id AND DATE(visit_date) = DATE(new.start_date)), 0));
    
    SET @drug_set1 = (SELECT COALESCE(drug_order_id1, '') FROM flat_table2 WHERE ID = @visit);
    
    SET @drug_set2 = (SELECT COALESCE(drug_order_id2, '') FROM flat_table2 WHERE ID = @visit);
    
    SET @drug_set3 = (SELECT COALESCE(drug_order_id3, '') FROM flat_table2 WHERE ID = @visit);
    
    SET @drug_set4 = (SELECT COALESCE(drug_order_id4, '') FROM flat_table2 WHERE ID = @visit);
    
    SET @drug_set5 = (SELECT COALESCE(drug_order_id5, '') FROM flat_table2 WHERE ID = @visit);

    CASE 
        WHEN @drug_set1 = "" THEN
            IF new.voided = 0 THEN
              IF @visit = 0 THEN
              
                  INSERT INTO flat_table2 (patient_id, visit_date, drug_order_id1, 
                      drug_encounter_id1, drug_start_date1, drug_auto_expire_date1, drug_order_id1_enc_id, 
                      drug_encounter_id1_enc_id, drug_start_date1_enc_id, drug_auto_expire_date1_enc_id) 
                  VALUES (@patient_id, in_visit_date, new.order_id, new.encounter_id, 
                      new.start_date, new.auto_expire_date, new.encounter_id, new.encounter_id, new.encounter_id, new.encounter_id);
              
              ELSE 

                  UPDATE flat_table2 SET drug_order_id1 = new.order_id, drug_encounter_id1 = new.encounter_id, 
                      drug_start_date1 = new.start_date, drug_auto_expire_date1 = new.auto_expire_date,
                      drug_order_id1_enc_id = new.encounter_id, drug_encounter_id1_enc_id = new.encounter_id, 
                      drug_start_date1_enc_id = new.encounter_id, drug_auto_expire_date1_enc_id = new.encounter_id 
                  WHERE flat_table2.id = @visit;
             END IF;
           ELSE
             UPDATE flat_table2 SET drug_order_id1 = NULL, drug_encounter_id1 = NULL, 
                      drug_start_date1 = NULL, drug_auto_expire_date1 = NULL,
                      drug_order_id1_enc_id = NULL, drug_encounter_id1_enc_id = NULL, 
                      drug_start_date1_enc_id = NULL, drug_auto_expire_date1_enc_id = NULL 
                  WHERE flat_table2.id = @visit;
            END IF;                       
    
        WHEN @drug_set2 = "" THEN        
            IF new.voided = 0 THEN
              IF @visit = 0 THEN
              
                  INSERT INTO flat_table2 (patient_id, visit_date, drug_order_id2, 
                      drug_encounter_id2, drug_start_date2, drug_auto_expire_date2, drug_order_id2_enc_id, 
                      drug_encounter_id2_enc_id, drug_start_date2_enc_id, drug_auto_expire_date2_enc_id) 
                  VALUES (@patient_id, in_visit_date, new.order_id, new.encounter_id, 
                      new.start_date, new.auto_expire_date, new.encounter_id, new.encounter_id, new.encounter_id, new.encounter_id);
              
              ELSE 
              
                  UPDATE flat_table2 SET drug_order_id2 = new.order_id, drug_encounter_id2 = new.encounter_id, 
                      drug_start_date2 = new.start_date, drug_auto_expire_date2 = new.auto_expire_date ,
                      drug_order_id2_enc_id = new.encounter_id, drug_encounter_id2_enc_id = new.encounter_id, 
                      drug_start_date2_enc_id = new.encounter_id, drug_auto_expire_date2_enc_id = new.encounter_id
                  WHERE flat_table2.id = @visit;
                  
              END IF;                          
           ELSE
             UPDATE flat_table2 SET drug_order_id2 = NULL, drug_encounter_id2 = NULL, 
                      drug_start_date2 = NULL, drug_auto_expire_date2 = NULL ,
                      drug_order_id2_enc_id = NULL, drug_encounter_id2_enc_id = NULL, 
                      drug_start_date2_enc_id = NULL, drug_auto_expire_date2_enc_id = NULL
             WHERE flat_table2.id = @visit;           
           END IF;
        WHEN @drug_set3 = "" THEN
            IF new.voided = 0 THEN
              IF @visit = 0 THEN
              
                  INSERT INTO flat_table2 (patient_id, visit_date, drug_order_id3, 
                      drug_encounter_id3, drug_start_date3, drug_auto_expire_date3, drug_order_id3_enc_id, 
                      drug_encounter_id3_enc_id, drug_start_date3_enc_id, drug_auto_expire_date3_enc_id) 
                  VALUES (@patient_id, in_visit_date, new.order_id, new.encounter_id, 
                      new.start_date, new.auto_expire_date, new.encounter_id, new.encounter_id, new.encounter_id, new.encounter_id);
              
              ELSE 
              
                  UPDATE flat_table2 SET drug_order_id3 = new.order_id, drug_encounter_id3 = new.encounter_id, 
                      drug_start_date3 = new.start_date, drug_auto_expire_date3 = new.auto_expire_date,
                      drug_order_id3_enc_id = new.encounter_id, drug_encounter_id3_enc_id = new.encounter_id, 
                      drug_start_date3_enc_id = new.encounter_id, drug_auto_expire_date3_enc_id = new.encounter_id 
                  WHERE flat_table2.id = @visit;
                  
              END IF;
            ELSE
              UPDATE flat_table2 SET drug_order_id3 = NULL, drug_encounter_id3 = NULL, 
                      drug_start_date3 = NULL, drug_auto_expire_date3 = NULL,
                      drug_order_id3_enc_id = NULL, drug_encounter_id3_enc_id = NULL, 
                      drug_start_date3_enc_id = NULL, drug_auto_expire_date3_enc_id = NULL 
                  WHERE flat_table2.id = @visit;
            END IF;                     
    
        WHEN @drug_set4 = "" THEN
            IF new.voided = 0 THEN
              IF @visit = 0 THEN
              
                  INSERT INTO flat_table2 (patient_id, visit_date, drug_order_id4, 
                      drug_encounter_id4, drug_start_date4, drug_auto_expire_date4, drug_order_id4_enc_id, 
                      drug_encounter_id4_enc_id, drug_start_date4_enc_id, drug_auto_expire_date4_enc_id) 
                  VALUES (@patient_id, in_visit_date, new.order_id, new.encounter_id, 
                      new.start_date, new.auto_expire_date, new.encounter_id, new.encounter_id, new.encounter_id, new.encounter_id);
              
              ELSE 
              
                  UPDATE flat_table2 SET drug_order_id4 = new.order_id, drug_encounter_id4 = new.encounter_id, 
                      drug_start_date4 = new.start_date, drug_auto_expire_date4 = new.auto_expire_date,
                      drug_order_id4_enc_id = new.encounter_id, drug_encounter_id4_enc_id = new.encounter_id, 
                      drug_start_date4_enc_id = new.encounter_id, drug_auto_expire_date4_enc_id = new.encounter_id 
                  WHERE flat_table2.id = @visit;
                  
              END IF;
           ELSE
             UPDATE flat_table2 SET drug_order_id4 = NULL, drug_encounter_id4 = NULL, 
                      drug_start_date4 = NULL, drug_auto_expire_date4 = NULL,
                      drug_order_id4_enc_id = NULL, drug_encounter_id4_enc_id = NULL, 
                      drug_start_date4_enc_id = NULL, drug_auto_expire_date4_enc_id = NULL
                  WHERE flat_table2.id = @visit;
           END IF;                       
    
        WHEN @drug_set5 = "" THEN
            IF new.voided = 0 THEN
              IF @visit = 0 THEN
              
                  INSERT INTO flat_table2 (patient_id, visit_date, drug_order_id5, 
                      drug_encounter_id5, drug_start_date5, drug_auto_expire_date5, drug_order_id5_enc_id, 
                      drug_encounter_id5_enc_id, drug_start_date5_enc_id, drug_auto_expire_date5_enc_id) 
                  VALUES (@patient_id, in_visit_date, new.order_id, new.encounter_id, 
                      new.start_date, new.auto_expire_date, new.encounter_id, new.encounter_id, new.encounter_id, new.encounter_id);
              
              ELSE 
              
                  UPDATE flat_table2 SET drug_order_id5 = new.order_id, drug_encounter_id5 = new.encounter_id, 
                      drug_start_date5 = new.start_date, drug_auto_expire_date5 = new.auto_expire_date,
                      drug_order_id5_enc_id = new.encounter_id, drug_encounter_id5_enc_id = new.encounter_id, 
                      drug_start_date5_enc_id = new.encounter_id, drug_auto_expire_date5_enc_id = new.encounter_id 
                  WHERE flat_table2.id = @visit;
                  
              END IF;
            ELSE
              UPDATE flat_table2 SET drug_order_id5 = NULL, drug_encounter_id5 = NULL, 
                      drug_start_date5 = NULL, drug_auto_expire_date5 = NULL,
                      drug_order_id5_enc_id = NULL, drug_encounter_id5_enc_id = NULL, 
                      drug_start_date5_enc_id = NULL, drug_auto_expire_date5_enc_id = NULL 
                  WHERE flat_table2.id = @visit;
            END IF;  
            
        ELSE
        
           SET @visit = 0;                      
    
    END CASE;

END$$

DELIMITER ;

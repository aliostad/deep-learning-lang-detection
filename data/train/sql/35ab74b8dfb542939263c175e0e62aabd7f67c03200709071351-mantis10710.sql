DELIMITER |

ALTER TABLE `vehicle` ADD COLUMN `modifying_agent_id` INTEGER UNSIGNED NOT NULL DEFAULT 1 AFTER `title_state` |

CREATE DEFINER='ecashtrigger'@'%' TRIGGER
    `vehicle_update` 
BEFORE UPDATE ON 
    `vehicle`
FOR EACH ROW
BEGIN
        IF(LOWER(NEW.vin) != LOWER(OLD.vin)) THEN
                INSERT INTO application_audit (date_created, company_id, application_id, table_name, column_name, value_before, value_after,
                update_process,agent_id)
                VALUES (now(), (select company_id from application where application_id=NEW.application_id), NEW.application_id, 'vehicle', 'vin', OLD.vin, NEW.vin,
                 'mysql::trigger:vehicle_update', NEW.modifying_agent_id);
        END IF;
        IF(LOWER(NEW.license_plate) != LOWER(OLD.license_plate)) THEN
                INSERT INTO application_audit (date_created, company_id, application_id, table_name, column_name, value_before, value_after,
                update_process,agent_id)
                VALUES (now(), (select company_id from application where application_id=NEW.application_id), NEW.application_id, 'vehicle', 'license_plate', OLD.license_plate, NEW.license_plate,
                 'mysql::trigger:vehicle_update', NEW.modifying_agent_id);
        END IF;
        IF(LOWER(NEW.make) != LOWER(OLD.make)) THEN
                INSERT INTO application_audit (date_created, company_id, application_id, table_name, column_name, value_before, value_after,
                update_process,agent_id)
                VALUES (now(), (select company_id from application where application_id=NEW.application_id), NEW.application_id, 'vehicle', 'make', OLD.make, NEW.make,
                 'mysql::trigger:vehicle_update', NEW.modifying_agent_id);
        END IF;
        IF(LOWER(NEW.model) != LOWER(OLD.model)) THEN
                INSERT INTO application_audit (date_created, company_id, application_id, table_name, column_name, value_before, value_after,
                update_process,agent_id)
                VALUES (now(), (select company_id from application where application_id=NEW.application_id), NEW.application_id, 'vehicle', 'model', OLD.model, NEW.model,
                 'mysql::trigger:vehicle_update', NEW.modifying_agent_id);
        END IF; 
        IF(LOWER(NEW.series) != LOWER(OLD.series)) THEN
                INSERT INTO application_audit (date_created, company_id, application_id, table_name, column_name, value_before, value_after,
                update_process,agent_id)
                VALUES (now(), (select company_id from application where application_id=NEW.application_id), NEW.application_id, 'vehicle', 'series', OLD.series, NEW.series,
                 'mysql::trigger:vehicle_update', NEW.modifying_agent_id);
        END IF;   
        IF(LOWER(NEW.style) != LOWER(OLD.style)) THEN
                INSERT INTO application_audit (date_created, company_id, application_id, table_name, column_name, value_before, value_after,
                update_process,agent_id)
                VALUES (now(), (select company_id from application where application_id=NEW.application_id), NEW.application_id, 'vehicle', 'style', OLD.style, NEW.style,
                 'mysql::trigger:vehicle_update', NEW.modifying_agent_id);
        END IF;   
        IF(LOWER(NEW.color) != LOWER(OLD.color)) THEN
                INSERT INTO application_audit (date_created, company_id, application_id, table_name, column_name, value_before, value_after,
                update_process,agent_id)
                VALUES (now(), (select company_id from application where application_id=NEW.application_id), NEW.application_id, 'vehicle', 'color', OLD.color, NEW.color,
                 'mysql::trigger:vehicle_update', NEW.modifying_agent_id);
        END IF;
        IF(LOWER(NEW.year) != LOWER(OLD.year)) THEN
                INSERT INTO application_audit (date_created, company_id, application_id, table_name, column_name, value_before, value_after,
                update_process,agent_id)
                VALUES (now(), (select company_id from application where application_id=NEW.application_id), NEW.application_id, 'vehicle', 'year', OLD.year, NEW.year,
                 'mysql::trigger:vehicle_update', NEW.modifying_agent_id);
        END IF;
        IF(LOWER(NEW.mileage) != LOWER(OLD.mileage)) THEN
                INSERT INTO application_audit (date_created, company_id, application_id, table_name, column_name, value_before, value_after,
                update_process,agent_id)
                VALUES (now(), (select company_id from application where application_id=NEW.application_id), NEW.application_id, 'vehicle', 'mileage', OLD.mileage, NEW.mileage,
                 'mysql::trigger:vehicle_update', NEW.modifying_agent_id);
        END IF;
        IF(LOWER(NEW.value) != LOWER(OLD.value)) THEN
                INSERT INTO application_audit (date_created, company_id, application_id, table_name, column_name, value_before, value_after,
                update_process,agent_id)
                VALUES (now(), (select company_id from application where application_id=NEW.application_id), NEW.application_id, 'vehicle', 'value', OLD.value, NEW.value,
                 'mysql::trigger:vehicle_update', NEW.modifying_agent_id);
        END IF;
        IF(LOWER(NEW.title_state) != LOWER(OLD.title_state)) THEN
                INSERT INTO application_audit (date_created, company_id, application_id, table_name, column_name, value_before, value_after,
                update_process,agent_id)
                VALUES (now(), (select company_id from application where application_id=NEW.application_id), NEW.application_id, 'vehicle', 'title_state', OLD.title_state, NEW.title_state,
                 'mysql::trigger:vehicle_update', NEW.modifying_agent_id);
        END IF;
        SET NEW.date_modified = now();
END |

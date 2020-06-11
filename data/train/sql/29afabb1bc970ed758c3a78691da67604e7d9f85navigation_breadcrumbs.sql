DROP function if exists navigation_breadcrumbs;
DELIMITER $$
CREATE FUNCTION navigation_breadcrumbs(nav_id INT(11) UNSIGNED) RETURNS VARCHAR(255) 
BEGIN
DECLARE var_name VARCHAR(255);
DECLARE id INT(11);
IF nav_id IS NULL THEN 
  SET id = 1;
ELSE
  SET id = nav_id;
END IF;
SELECT      
  CONCAT( 
    if(t6.label is not null and t6.lvl>0, CONCAT(t6.label, ' > '),''),  
    if(t5.label is not null and t5.lvl>0, CONCAT(t5.label, ' > '),''),
    if(t4.label is not null and t4.lvl>0, CONCAT(t4.label, ' > '),''),
    if(t3.label is not null and t3.lvl>0, CONCAT(t3.label, ' > '),''),
    if(t2.label is not null and t2.lvl>0, CONCAT(t2.label, ' > '),''),                
    if(nav.label is not null and nav.lvl>0, nav.label,''))                
    INTO var_name
 FROM navigation AS nav
LEFT JOIN navigation AS t2 ON t2.id = nav.parent_id
LEFT JOIN navigation AS t3 ON t3.id = t2.parent_id
LEFT JOIN navigation AS t4 ON t4.id = t3.parent_id
LEFT JOIN navigation AS t5 ON t5.id = t4.parent_id
LEFT JOIN navigation AS t6 ON t6.id = t5.parent_id
WHERE nav.id = id 
limit 1;
RETURN var_name;
END$$
DELIMITER;
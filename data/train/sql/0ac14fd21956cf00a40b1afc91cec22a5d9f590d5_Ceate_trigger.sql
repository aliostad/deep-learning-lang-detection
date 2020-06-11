# 5 Ceate trigger
Update
delimiter //
CREATE TRIGGER m_productUpdate
AFTER UPDATE ON tblProducts
FOR EACH ROW
BEGIN
    INSERT INTO tblbk_product(Pro_code,Pro_name,Pro_cost,Pro_quantity,Pro_date,Sup_id)
    VALUES(old.Pro_code,old.Pro_name,old.Pro_cost,old.Pro_quantity,old.Pro_date,old.Sup_id);
END;
//
Delete
delimiter //
CREATE TRIGGER mdb_product
AFTER DELETE ON tblProducts
FOR EACH ROW
BEGIN
    INSERT INTO tblbk_product(Pro_code,Pro_name,Pro_cost,Pro_quantity,Pro_date,Sup_id)
    VALUES(old.Pro_code,old.Pro_name,old.Pro_cost,old.Pro_quantity,old.Pro_date,old.Sup_id);
END;
//

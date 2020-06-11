DELIMITER //
/*
|-------------------------------------------------------- 
| dansi_product_new
| 
| Creates a new product in the products table.
|-------------------------------------------------------- 
*/

DROP PROCEDURE IF EXISTS NewProduct;
DROP PROCEDURE IF EXISTS dansi_product_new;

CREATE PROCEDURE `dansi_product_new` (
    IN inname VARCHAR(250)
    ,IN inprice INT
    ,IN indescript TEXT
    ,IN inimg VARCHAR(250)
    ,IN inimg_thumb VARCHAR(250)
    )

  BEGIN

    DECLARE newID INT;

    INSERT INTO `dansi_products` (
      `name`
      ,`price`
      ,`descript`
      ,`img`
      ,`img_thumb`
    )

    VALUES (
      inname
      ,inprice
      ,indescript
      ,inimg
      ,inimg_thumb
    )
    ;

    SET newID = LAST_INSERT_ID();

    INSERT INTO `dansi_sales` (
      `id_product`
      ,`num`
    )

    VALUES (
      newID
      ,0
    )
    ;


  END//

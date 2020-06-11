  --Item View

  SELECT dropIfExists('VIEW', 'item', 'api');
  CREATE OR REPLACE VIEW api.item AS

  SELECT
    item_number::varchar AS item_number,
    item_active AS active,
    item_descrip1 AS description1,
    item_descrip2 AS description2,
    CASE
      WHEN item_type = 'P' THEN
        'Purchased'
      WHEN item_type = 'M' THEN
        'Manufactured'
      WHEN item_type = 'J' THEN
        'Job'
      WHEN item_type = 'K' THEN
        'Kit'
      WHEN item_type = 'F' THEN
        'Phantom'
      WHEN item_type = 'R' THEN
        'Reference'
      WHEN item_type = 'S' THEN
        'Costing'
      WHEN item_type = 'T' THEN
        'Tooling'
      WHEN item_type = 'O' THEN
        'Outside Process'
      WHEN item_type = 'L' THEN
        'Planning'
      WHEN item_type = 'B' THEN
        'Breeder'
      WHEN item_type = 'C' THEN
        'Co-Product'
      WHEN item_type = 'Y' THEN
        'By-Product'
    END AS item_type,
    item_maxcost AS maximum_desired_cost,
    classcode_code AS class_code,
    i.uom_name AS inventory_uom,
    item_picklist AS pick_list_item,
    item_fractional AS fractional,
    item_config AS configured,
    item_sold AS item_is_sold,
    prodcat_code AS product_category,
    item_exclusive AS exclusive,
    item_listprice AS list_price,
    item_listcost AS list_cost,
    p.uom_name AS list_price_uom,
    item_upccode AS upc_code,
    item_prodweight AS product_weight,
    item_packweight AS packaging_weight,
    item_comments AS notes,
    item_extdescrip AS ext_description
  FROM item
         LEFT OUTER JOIN prodcat ON (item_prodcat_id=prodcat_id), 
         classcode, uom AS i, uom AS p
  WHERE ((item_classcode_id=classcode_id)
  AND (item_inv_uom_id=i.uom_id)
  AND (item_price_uom_id=p.uom_id))
  ORDER BY item_number;

GRANT ALL ON TABLE api.item TO xtrole;
COMMENT ON VIEW api.item IS 'Item';

  --Rules

  CREATE OR REPLACE RULE "_INSERT" AS
    ON INSERT TO api.item DO INSTEAD

  INSERT INTO item
	   (item_number,
	    item_active,
	    item_descrip1,
	    item_descrip2,
	    item_type,
	    item_maxcost,
	    item_classcode_id,
	    item_inv_uom_id,
	    item_picklist,
	    item_fractional,
	    item_config,
	    item_sold,
	    item_prodcat_id,
	    item_exclusive,
	    item_listprice,
	    item_listcost,
	    item_price_uom_id,
	    item_upccode,
	    item_prodweight,
	    item_packweight,
	    item_comments,
	    item_extdescrip)
	   VALUES
	   (UPPER(NEW.item_number),
	    COALESCE(NEW.active,TRUE),
	    COALESCE(NEW.description1,''),
	    COALESCE(NEW.description2,''),
	    CASE
	      WHEN NEW.item_type = 'Purchased' THEN
	        'P'
	      WHEN NEW.item_type = 'Manufactured' THEN
	        'M'
	      WHEN NEW.item_type = 'Job' THEN
	        'J'
	      WHEN NEW.item_type = 'Kit' THEN
	        'K'
	      WHEN NEW.item_type = 'Phantom' THEN
	        'F'
	      WHEN NEW.item_type = 'Reference' THEN
	        'R'
	      WHEN NEW.item_type = 'Costing' THEN
	        'S'
	      WHEN NEW.item_type = 'Tooling' THEN
	        'T'
	      WHEN NEW.item_type = 'Outside Process' THEN
	        'O'
	      WHEN NEW.item_type = 'Planning' THEN
	        'L'
	      WHEN NEW.item_type = 'Breeder' THEN
	        'B'
	      WHEN NEW.item_type = 'Co-Product' THEN
	        'C'
	      WHEN NEW.item_type = 'By-Product' THEN
	        'Y'
	    END,
	    COALESCE(NEW.maximum_desired_cost,0),
	    getClassCodeId(NEW.class_code),
	    getUomId(NEW.inventory_uom),
	    COALESCE(NEW.pick_list_item,TRUE),
	    COALESCE(NEW.fractional,FALSE),
	    COALESCE(NEW.configured,FALSE),
	    COALESCE(NEW.item_is_sold,TRUE),
	    COALESCE(getProdCatId(NEW.product_category),-1),
	    COALESCE(NEW.exclusive,FALSE),
	    COALESCE(NEW.list_price,0),
	    COALESCE(NEW.list_cost,0),
	    COALESCE(getUomId(NEW.list_price_uom),getUomId(NEW.inventory_uom)),
	    NEW.upc_code,
	    COALESCE(NEW.product_weight,0),
	    COALESCE(NEW.packaging_weight,0),
	    NEW.notes,
	    NEW.ext_description);
 
    CREATE OR REPLACE RULE "_UPDATE" AS
    ON UPDATE TO api.item DO INSTEAD

    UPDATE item SET
      item_active=NEW.active,
      item_descrip1=NEW.description1,
      item_descrip2=NEW.description2,
      item_type=
     	    CASE
	      WHEN NEW.item_type = 'Purchased' THEN
	        'P'
	      WHEN NEW.item_type = 'Manufactured' THEN
	        'M'
	      WHEN NEW.item_type = 'Job' THEN
	        'J'
	      WHEN NEW.item_type = 'Kit' THEN
	        'K'
	      WHEN NEW.item_type = 'Phantom' THEN
	        'F'
	      WHEN NEW.item_type = 'Reference' THEN
	        'R'
	      WHEN NEW.item_type = 'Costing' THEN
	        'S'
	      WHEN NEW.item_type = 'Tooling' THEN
	        'T'
	      WHEN NEW.item_type = 'Outside Process' THEN
	        'O'
	      WHEN NEW.item_type = 'Planning' THEN
	        'L'
	      WHEN NEW.item_type = 'Breeder' THEN
	        'B'
	      WHEN NEW.item_type = 'Co-Product' THEN
	        'C'
	      WHEN NEW.item_type = 'By-Product' THEN
	        'Y'
	    END,
      item_maxcost=NEW.maximum_desired_cost,
      item_classcode_id=getClassCodeId(NEW.class_code),
      item_inv_uom_id=getUomId(NEW.inventory_uom),
      item_picklist=NEW.pick_list_item,
      item_fractional=NEW.fractional,
      item_config=NEW.configured,
      item_sold=NEW.item_is_sold,
      item_prodcat_id=COALESCE(getProdCatId(NEW.product_category),-1),
      item_exclusive=NEW.exclusive,
      item_listprice=NEW.list_price,
      item_listcost=NEW.list_cost,
      item_price_uom_id=getUomId(NEW.list_price_uom),
      item_upccode=NEW.upc_code,
      item_prodweight=NEW.product_weight,
      item_packweight=NEW.packaging_weight,
      item_comments=NEW.notes,
      item_extdescrip=NEW.ext_description
    WHERE (item_id=getItemId(OLD.item_number));

    CREATE OR REPLACE RULE "_DELETE" AS
    ON DELETE TO api.item DO INSTEAD

    SELECT deleteitem(getItemId(OLD.item_number));

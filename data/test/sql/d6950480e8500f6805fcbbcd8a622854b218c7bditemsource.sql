-- Item Source

SELECT dropIfExists('VIEW', 'itemsource', 'api');

CREATE VIEW api.itemsource AS
  SELECT item.item_number::VARCHAR AS item_number,
       vendinfo.vend_number::VARCHAR AS vendor, 
       itemsrc.itemsrc_vend_item_number AS vendor_item_number, 
       itemsrc.itemsrc_active AS active,
       itemsrc.itemsrc_default AS itemsrc_default,
       itemsrc.itemsrc_vend_uom AS vendor_uom, 
       itemsrc.itemsrc_invvendoruomratio AS inventory_vendor_uom_ratio, 
       itemsrc.itemsrc_minordqty AS minimum_order, 
       itemsrc.itemsrc_multordqty AS order_multiple,  
       itemsrc.itemsrc_ranking AS vendor_ranking, 
       itemsrc.itemsrc_leadtime AS lead_time,
       itemsrc.itemsrc_comments AS notes, 
       itemsrc.itemsrc_vend_item_descrip AS vendor_description,
       itemsrc.itemsrc_manuf_name AS manufacturer_name,
       itemsrc.itemsrc_manuf_item_number AS manufacturer_item_number,
       itemsrc.itemsrc_manuf_item_descrip AS manufacturer_description,
       itemsrc.itemsrc_upccode AS bar_code,
       contrct.contrct_number AS contract_number,
       itemsrc.itemsrc_effective AS effective_date,
       itemsrc.itemsrc_expires AS expires_date
   FROM itemsrc
   LEFT JOIN item ON itemsrc.itemsrc_item_id = item.item_id
   LEFT JOIN vendinfo ON itemsrc.itemsrc_vend_id = vendinfo.vend_id
   LEFT JOIN contrct ON itemsrc.itemsrc_contrct_id = contrct.contrct_id
  ORDER BY item.item_number::VARCHAR(100), vendinfo.vend_number::VARCHAR(100);
        
GRANT ALL ON TABLE api.itemsource TO xtrole;
COMMENT ON VIEW api.itemsource IS 'Item Source';

-- Rules

CREATE OR REPLACE RULE "_INSERT" AS
    ON INSERT TO api.itemsource DO INSTEAD
    
  INSERT INTO itemsrc (
    itemsrc_item_id, 
    itemsrc_vend_id, 
    itemsrc_vend_item_number, 
    itemsrc_vend_item_descrip, 
    itemsrc_comments, 
    itemsrc_vend_uom, 
    itemsrc_invvendoruomratio, 
    itemsrc_minordqty, 
    itemsrc_multordqty, 
    itemsrc_leadtime, 
    itemsrc_ranking, 
    itemsrc_active,
    itemsrc_default,
    itemsrc_manuf_name,
    itemsrc_manuf_item_number,
    itemsrc_manuf_item_descrip,
    itemsrc_upccode,
    itemsrc_contrct_id,
    itemsrc_effective,
    itemsrc_expires) 
  VALUES (
    getitemid(NEW.item_number), 
    getvendid(NEW.vendor), 
    NEW.vendor_item_number, 
    COALESCE(NEW.vendor_description, ''), 
    COALESCE(NEW.notes, ''), 
    NEW.vendor_uom, 
    NEW.inventory_vendor_uom_ratio, 
    NEW.minimum_order, 
    NEW.order_multiple, 
    NEW.lead_time, 
    NEW.vendor_ranking, 
    COALESCE(NEW.active, true),
    COALESCE(NEW.itemsrc_default, true),
    COALESCE(NEW.manufacturer_name,''),
    COALESCE(NEW.manufacturer_item_number,''),
    NEW.manufacturer_description,
    NEW.bar_code,
    getcontrctid(NEW.contract_number),
    COALESCE(getcontrcteffective(NEW.contract_number), NEW.effective_date),
    COALESCE(getcontrctexpires(NEW.contract_number), NEW.expires_date))
;

CREATE OR REPLACE RULE "_UPDATE" AS 
    ON UPDATE TO api.itemsource DO INSTEAD
    
  UPDATE itemsrc SET 
    itemsrc_vend_item_number = NEW.vendor_item_number, 
    itemsrc_vend_item_descrip = NEW.vendor_description, 
    itemsrc_comments = NEW.notes, 
    itemsrc_vend_uom = NEW.vendor_uom, 
    itemsrc_invvendoruomratio = NEW.inventory_vendor_uom_ratio, 
    itemsrc_minordqty = NEW.minimum_order, 
    itemsrc_multordqty = NEW.order_multiple, 
    itemsrc_leadtime = NEW.lead_time, 
    itemsrc_ranking = NEW.vendor_ranking, 
    itemsrc_active = NEW.active,
    itemsrc_default = NEW.itemsrc_default,
    itemsrc_manuf_name = NEW.manufacturer_name,
    itemsrc_manuf_item_number = NEW.manufacturer_item_number,
    itemsrc_manuf_item_descrip = NEW.manufacturer_description,
    itemsrc_upccode=NEW.bar_code,
    itemsrc_contrct_id=getcontrctid(NEW.contract_number),
    itemsrc_effective=COALESCE(getcontrcteffective(NEW.contract_number), NEW.effective_date),
    itemsrc_expires=COALESCE(getcontrctexpires(NEW.contract_number), NEW.expires_date)
  WHERE ((itemsrc.itemsrc_item_id = getitemid(old.item_number)) 
  AND (itemsrc.itemsrc_vend_id = getvendid(old.vendor))
  AND (itemsrc.itemsrc_vend_item_number=old.vendor_item_number)
  AND (itemsrc.itemsrc_manuf_name=old.manufacturer_name)
  AND (itemsrc.itemsrc_manuf_item_number=old.manufacturer_item_number));

CREATE OR REPLACE RULE "_DELETE" AS 
    ON DELETE TO api.itemsource DO INSTEAD
    
  DELETE FROM itemsrc
  WHERE ((itemsrc.itemsrc_item_id = getitemid(old.item_number)) 
  AND (itemsrc.itemsrc_vend_id = getvendid(old.vendor))
  AND (itemsrc.itemsrc_vend_item_number=old.vendor_item_number)
  AND (itemsrc.itemsrc_manuf_name=old.manufacturer_name)
  AND (itemsrc.itemsrc_manuf_item_number=old.manufacturer_item_number));

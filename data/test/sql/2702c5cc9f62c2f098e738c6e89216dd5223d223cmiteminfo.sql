select xt.create_view('xt.cmiteminfo', $$

select cmitem.*,
  itemsite_item_id as cmitem_item_id,
  itemsite_warehous_id as cmitem_warehous_id
from cmitem
  join itemsite on cmitem_itemsite_id = itemsite_id;

$$, false);

create or replace rule "_INSERT" as on insert to xt.cmiteminfo do instead

  insert into cmitem (
    cmitem_id,
    cmitem_cmhead_id,
    cmitem_linenumber,
    cmitem_itemsite_id,
    cmitem_qtycredit,
    cmitem_qtyreturned,
    cmitem_unitprice,
    cmitem_comments,
    cmitem_rsncode_id,
    cmitem_taxtype_id,
    cmitem_qty_uom_id,
    cmitem_qty_invuomratio,
    cmitem_price_uom_id,
    cmitem_price_invuomratio,
    cmitem_raitem_id,
    cmitem_updateinv,
    obj_uuid
  ) select
    new.cmitem_id,
    new.cmitem_cmhead_id,
    new.cmitem_linenumber,
    itemsite_id,
    new.cmitem_qtycredit,
    new.cmitem_qtyreturned,
    new.cmitem_unitprice,
    new.cmitem_comments,
    new.cmitem_rsncode_id,
    new.cmitem_taxtype_id,
    new.cmitem_qty_uom_id,
    new.cmitem_qty_invuomratio,
    new.cmitem_price_uom_id,
    new.cmitem_price_invuomratio,
    new.cmitem_raitem_id,
    COALESCE(new.cmitem_updateinv, false),
    new.obj_uuid
  from itemsite
  where itemsite_item_id=new.cmitem_item_id
  and itemsite_warehous_id=new.cmitem_warehous_id;

create or replace rule "_UPDATE" as on update to xt.cmiteminfo do instead

  update cmitem set
  cmitem_cmhead_id = new.cmitem_cmhead_id,
  cmitem_linenumber = new.cmitem_linenumber,
  cmitem_itemsite_id = new.cmitem_itemsite_id,
  cmitem_qtycredit = new.cmitem_qtycredit,
  cmitem_qtyreturned = new.cmitem_qtyreturned,
  cmitem_unitprice = new.cmitem_unitprice,
  cmitem_comments = new.cmitem_comments,
  cmitem_rsncode_id = new.cmitem_rsncode_id,
  cmitem_taxtype_id = new.cmitem_taxtype_id,
  cmitem_qty_uom_id = new.cmitem_qty_uom_id,
  cmitem_qty_invuomratio = new.cmitem_qty_invuomratio,
  cmitem_price_uom_id = new.cmitem_price_uom_id,
  cmitem_price_invuomratio = new.cmitem_price_invuomratio,
  cmitem_raitem_id = new.cmitem_raitem_id,
  cmitem_updateinv = new.cmitem_updateinv,
  obj_uuid = new.obj_uuid
  where cmitem_id = old.cmitem_id;

create or replace rule "_DELETE" as on delete to xt.cmiteminfo do instead

  delete from cmitem where cmitem_id = old.cmitem_id;


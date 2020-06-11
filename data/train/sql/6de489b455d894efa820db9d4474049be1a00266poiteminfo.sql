select xt.create_view('xt.poiteminfo', $$

select poitem.*,
  itemsite_item_id as item_id,
  itemsite_warehous_id as warehous_id,
  case when poitem_itemsite_id is null then true else false end as poitem_is_misc,
  pohead_curr_id as curr_id,
  xt.po_line_extended_price(poitem) as extended_price,
  xt.po_line_tax(poitem) as tax,
  coalesce(poitem_qty_toreceive,0) as qty_toreceive
from poitem
  left join itemsite on itemsite_id=poitem_itemsite_id
  join pohead on pohead_id=poitem_pohead_id;

$$, false);

create or replace rule "_INSERT" as on insert to xt.poiteminfo do instead

insert into poitem (
  poitem_id,
  poitem_status,
  poitem_pohead_id,
  poitem_linenumber,
  poitem_duedate,
  poitem_itemsite_id,
  poitem_vend_item_descrip,
  poitem_vend_uom,
  poitem_invvenduomratio,
  poitem_qty_ordered,
  poitem_qty_received,
  poitem_qty_returned,
  poitem_qty_vouchered,
  poitem_unitprice,
  poitem_vend_item_number,
  poitem_comments,
  poitem_qty_toreceive,
  poitem_expcat_id,
  poitem_itemsrc_id,
  poitem_freight,
  poitem_freight_received,
  poitem_freight_vouchered,
  poitem_prj_id,
  poitem_stdcost,
  poitem_bom_rev_id,
  poitem_boo_rev_id,
  poitem_manuf_name,
  poitem_manuf_item_number,
  poitem_manuf_item_descrip,
  poitem_taxtype_id,
  poitem_tax_recoverable,
  poitem_rlsd_duedate,
  poitem_order_id,
  poitem_order_type,
  obj_uuid
) values (
  new.poitem_id,
  new.poitem_status,
  new.poitem_pohead_id,
  new.poitem_linenumber,
  new.poitem_duedate,
  (select itemsite_id
   from itemsite
   where itemsite_item_id=new.item_id
     and itemsite_warehous_id=new.warehous_id),
  new.poitem_vend_item_descrip,
  new.poitem_vend_uom,
  new.poitem_invvenduomratio,
  new.poitem_qty_ordered,
  0,
  0,
  0,
  new.poitem_unitprice,
  new.poitem_vend_item_number,
  new.poitem_comments,
  new.poitem_qty_toreceive,
  new.poitem_expcat_id,
  new.poitem_itemsrc_id,
  coalesce(new.poitem_freight, 0.0),
  0,
  0,
  new.poitem_prj_id,
  new.poitem_stdcost,
  new.poitem_bom_rev_id,
  new.poitem_boo_rev_id,
  new.poitem_manuf_name,
  new.poitem_manuf_item_number,
  new.poitem_manuf_item_descrip,
  new.poitem_taxtype_id,
  true,
  new.poitem_rlsd_duedate,
  new.poitem_order_id,
  new.poitem_order_type,
  coalesce(new.obj_uuid, xt.uuid_generate_v4())
);

create or replace rule "_UPDATE" as on update to xt.poiteminfo do instead

update poitem set
  poitem_status=new.poitem_status,
  poitem_pohead_id=new.poitem_pohead_id,
  poitem_linenumber=new.poitem_linenumber,
  poitem_duedate=new.poitem_duedate,
  poitem_itemsite_id=(
   select itemsite_id
   from itemsite
   where itemsite_item_id=new.item_id
     and itemsite_warehous_id=new.warehous_id),
  poitem_vend_item_descrip=new.poitem_vend_item_descrip,
  poitem_vend_uom=new.poitem_vend_uom,
  poitem_invvenduomratio=new.poitem_invvenduomratio,
  poitem_qty_ordered=new.poitem_qty_ordered,
  poitem_qty_received=new.poitem_qty_received,
  poitem_qty_returned=new.poitem_qty_returned,
  poitem_qty_vouchered=new.poitem_qty_vouchered,
  poitem_unitprice=new.poitem_unitprice,
  poitem_vend_item_number=new.poitem_vend_item_number,
  poitem_comments=new.poitem_comments,
  poitem_qty_toreceive=new.poitem_qty_toreceive,
  poitem_expcat_id=new.poitem_expcat_id,
  poitem_itemsrc_id=new.poitem_itemsrc_id,
  poitem_freight=new.poitem_freight,
  poitem_freight_received=new.poitem_freight_received,
  poitem_freight_vouchered=new.poitem_freight_vouchered,
  poitem_prj_id=new.poitem_prj_id,
  poitem_stdcost=new.poitem_stdcost,
  poitem_bom_rev_id=new.poitem_bom_rev_id,
  poitem_boo_rev_id=new.poitem_boo_rev_id,
  poitem_manuf_name=new.poitem_manuf_name,
  poitem_manuf_item_number=new.poitem_manuf_item_number,
  poitem_manuf_item_descrip=new.poitem_manuf_item_descrip,
  poitem_taxtype_id=new.poitem_taxtype_id,
  poitem_tax_recoverable=new.poitem_tax_recoverable,
  poitem_rlsd_duedate=new.poitem_rlsd_duedate,
  poitem_order_id=new.poitem_order_id,
  poitem_order_type=new.poitem_order_type,
  obj_uuid=new.obj_uuid
where poitem_id = old.poitem_id;

create or replace rule "_DELETE" as on delete to xt.poiteminfo do instead

delete from poitem where poitem_id = old.poitem_id;

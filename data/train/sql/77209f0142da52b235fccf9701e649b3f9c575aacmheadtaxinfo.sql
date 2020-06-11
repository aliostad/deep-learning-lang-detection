select xt.create_view('xt.cmheadtaxinfo', $$
  -- multiply the tax amount by -1 so the client doesn't have to.

select
taxhist_id,
taxhist_parent_id,
taxhist_taxtype_id,
taxhist_tax_id,
taxhist_basis,
taxhist_basis_tax_id,
taxhist_sequence,
taxhist_percent,
taxhist_amount,
taxhist_tax * -1 as taxhist_tax,
taxhist_docdate,
taxhist_distdate,
taxhist_curr_id,
taxhist_curr_rate,
taxhist_journalnumber,
obj_uuid
from cmheadtax;

$$, false);


create or replace rule "_INSERT" as on insert to xt.cmheadtaxinfo do instead

  insert into cmheadtax (
    taxhist_id,
    taxhist_parent_id,
    taxhist_taxtype_id,
    taxhist_tax_id,
    taxhist_basis,
    taxhist_basis_tax_id,
    taxhist_sequence,
    taxhist_percent,
    taxhist_amount,
    taxhist_tax,
    taxhist_docdate,
    taxhist_distdate,
    taxhist_curr_id,
    taxhist_curr_rate,
    taxhist_journalnumber,
    obj_uuid
  ) values (
    new.taxhist_id,
    new.taxhist_parent_id,
    new.taxhist_taxtype_id,
    new.taxhist_tax_id,
    new.taxhist_basis,
    new.taxhist_basis_tax_id,
    new.taxhist_sequence,
    new.taxhist_percent,
    new.taxhist_amount,
    new.taxhist_tax * -1,
    new.taxhist_docdate,
    new.taxhist_distdate,
    new.taxhist_curr_id,
    new.taxhist_curr_rate,
    new.taxhist_journalnumber,
    new.obj_uuid
  );

create or replace rule "_UPDATE" as on update to xt.cmheadtaxinfo do instead

  update cmheadtax set
  taxhist_id = new.taxhist_id,
  taxhist_parent_id = new.taxhist_parent_id,
  taxhist_taxtype_id = new.taxhist_taxtype_id,
  taxhist_tax_id = new.taxhist_tax_id,
  taxhist_basis = new.taxhist_basis,
  taxhist_basis_tax_id = new.taxhist_basis_tax_id,
  taxhist_sequence = new.taxhist_sequence,
  taxhist_percent = new.taxhist_percent,
  taxhist_amount = new.taxhist_amount,
  taxhist_tax = new.taxhist_tax * -1,
  taxhist_docdate = new.taxhist_docdate,
  taxhist_distdate = new.taxhist_distdate,
  taxhist_curr_id = new.taxhist_curr_id,
  taxhist_curr_rate = new.taxhist_curr_rate,
  taxhist_journalnumber = new.taxhist_journalnumber,
  obj_uuid = new.obj_uuid
  where taxhist_id = old.taxhist_id;

create or replace rule "_DELETE" as on delete to xt.cmheadtaxinfo do instead

  delete from cmheadtax where taxhist_id = old.taxhist_id;



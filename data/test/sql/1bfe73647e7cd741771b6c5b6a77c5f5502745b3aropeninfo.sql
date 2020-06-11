select xt.create_view('xt.aropeninfo', $$

  select aropen.*,
    xt.ar_balance(aropen) as balance,
    xt.ar_tax_total(aropen.aropen_id) as tax_total
  from aropen;

$$,false);

create or replace rule "_INSERT" as on insert to xt.aropeninfo do instead nothing;
create or replace rule "_DELETE" as on delete to xt.aropeninfo do instead nothing;

create or replace rule "_UPDATE" as on update to xt.aropeninfo do instead

update aropen set
  aropen_id = new.aropen_id,
  aropen_cust_id = new.aropen_cust_id,
  aropen_doctype = new.aropen_doctype,
  aropen_docnumber = new.aropen_docnumber,
  aropen_posted = new.aropen_posted,
  aropen_open = new.aropen_open,
  aropen_docdate = new.aropen_docdate,
  aropen_duedate = new.aropen_duedate,
  aropen_amount = new.aropen_amount,
  aropen_curr_id = new.aropen_curr_id,
  aropen_paid = new.aropen_paid,
  aropen_notes = new.aropen_notes,
  aropen_closedate = new.aropen_closedate,
  aropen_terms_id = new.aropen_terms_id,
  aropen_applyto = new.aropen_terms_id,
  aropen_ponumber = new.aropen_ponumber,
  aropen_salesrep_id = new.aropen_salesrep_id,
  aropen_commission_due = new.aropen_commission_due,
  aropen_commission_paid = new.aropen_commission_paid,
  aropen_ordernumber = new.aropen_ordernumber,
  aropen_cobmisc_id = new.aropen_cobmisc_id,
  aropen_journalnumber = new.aropen_journalnumber,
  aropen_username = new.aropen_username,
  aropen_rsncode_id = new.aropen_rsncode_id,
  aropen_salescat_id = new.aropen_salescat_id,
  aropen_accnt_id = new.aropen_accnt_id,
  aropen_distdate = new.aropen_distdate,
  aropen_curr_rate = new.aropen_curr_rate,
  aropen_discount = new.aropen_discount
where aropen_id = old.aropen_id;

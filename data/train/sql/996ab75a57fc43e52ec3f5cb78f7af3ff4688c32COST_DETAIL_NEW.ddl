create table COST_DETAIL_NEW 
 (corp              number(4,0), 
  rev_center        varchar2(8 byte), 
  charge_code       varchar2(8 byte), 
  provider_type     varchar2(1 byte), 
  cpt_modifier      varchar2(4 byte), 
  cost_component    varchar2(35 byte), 
  rvu               number(20,8), 
  total_cost        number(20,8), 
  year              number(4,0), 
  quarter           number(1,0)
  );

create bitmap index cost_detail_new_charge_code on cost_detail_new (charge_code);

create bitmap index cost_detail_new_corp on cost_detail_new (corp);

create bitmap index cost_detail_new_cost_comp on cost_detail_new (cost_component);

create bitmap index cost_detail_new_modifier on cost_detail_new (cpt_modifier);

create bitmap index cost_detail_new_prov_type on cost_detail_new (provider_type);

create bitmap index cost_detail_new_quarter on cost_detail_new (quarter) ;

create bitmap index cost_detail_new_rev_ctr on cost_detail_new (rev_center);

create bitmap index cost_detail_new_year on cost_detail_new (year);
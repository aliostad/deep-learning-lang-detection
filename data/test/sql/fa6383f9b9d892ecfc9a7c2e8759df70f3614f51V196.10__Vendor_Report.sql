SET SQL_SAFE_UPDATES=0;
CREATE or replace VIEW `netplnactiv_content_vw` AS 
select `nav`.`year_mon` AS `Month`, 
bvm.vendor_code,
plan_id,plan,  bad.vendor_agmt_id ,
sum(`nav`.`Op_Active`) AS `Op_Bal`,
sum(`nav`.`new`) AS `New`,
sum(`nav`.`rec`) AS `Reconn`,
sum(`nav`.`ren`) AS `Renewal`,
(sum(`nav`.`Op_Pending_add`) + sum(`nav`.`Pending_add`)) AS `Pending_add`,
sum(((((`nav`.`new` + `nav`.`rec`) + `nav`.`ren`) + `nav`.`Op_Pending_add`) + `nav`.`Pending_add`)) AS `NetAdditions`,
sum(((((`nav`.`Op_Active` + `nav`.`new`) + `nav`.`rec`) + `nav`.`Op_Pending_add`) + `nav`.`Pending_add`)) AS `Total`,
sum(`nav`.`Del`) AS `Deletions`,
sum(`nav`.`Pending_del`) AS `Pending_del`,
sum(`nav`.`Cum_Pending`) AS `Cum_Pending`,
(sum(`nav`.`Del`) + sum(`nav`.`Pending_del`)) AS `NetSub`,
sum(((((((`nav`.`Op_Active` + `nav`.`new`) + `nav`.`rec`) + `nav`.`Op_Pending_add`) + `nav`.`Pending_add`) - `nav`.`Del`) - `nav`.`Pending_del`)) AS `NetBal`,
sum(`nav`.`Op_Active` + `nav`.`new` + `nav`.`rec`   - `nav`.`Del`)  AS `NetBalP`,
sum(`nav`.`Cl_Active`) AS `ClosingBal` ,
sum(content_cost)  Purchase_Cost ,
if(bvm.vendor_code = 'OSN',`nav`.`Cl_Active`,`nav`.`new`) ff ,
sum(if(bvm.vendor_code = 'OSN',`nav`.`Cl_Active`,`nav`.`new`)  * bad.content_cost) Net_Purchase_Cost,
sum(if(bvm.vendor_code = 'OSN',`nav`.`Cl_Active`,`nav`.`new`)  * bad.content_sellprice ) Content_Sell,
sum(if(bvm.vendor_code = 'OSN',`nav`.`Cl_Active`,`nav`.`new`)  * bad.content_sellprice )  - 
sum(if(bvm.vendor_code = 'OSN',`nav`.`Cl_Active`,`nav`.`new`)  * content_cost) NetMarkup,
TRUNCATE(( sum( if(bvm.vendor_code = 'OSN',`nav`.`Cl_Active`,`nav`.`new`)  * bad.content_cost) * loyalty_share /100 ),2) Commission,
TRUNCATE(sum(if(bvm.vendor_code = 'OSN',`nav`.`Cl_Active`,`nav`.`new`)  * bad.content_sellprice )  
- sum( if(bvm.vendor_code = 'OSN',`nav`.`Cl_Active`,`nav`.`new`)  * content_cost) +
(sum( if(bvm.vendor_code = 'OSN',`nav`.`Cl_Active`,`nav`.`new`)  * bad.content_cost) * loyalty_share /100 ),2) Profit
from `net_activedtls_vw` nav 
left join  b_vendor_agmt_detail bad on ( nav.plan_id = bad.content_code and content_cost is not null)
left join b_order_price bop on (nav.order_id = bop.order_id )
left join b_vendor_agreement bva on (bva.id = bad.vendor_agmt_id )
left join b_vendor_management bvm on (bva.vendor_id = bvm.id)
group by `nav`.`year_mon` ,plan_id,plan, bvm.vendor_code
order by `nav`.`month_number`;

UPDATE stretchy_report SET report_name='Vendor Commission Report' WHERE report_name='Plan wise Revenue Report for Vendor';

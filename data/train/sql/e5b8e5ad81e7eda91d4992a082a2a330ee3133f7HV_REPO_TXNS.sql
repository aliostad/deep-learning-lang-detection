
  CREATE OR REPLACE  VIEW HV_REPO_TXNS (MODULE_REF, COMPANY, DIVISION, PORTFOLIO, PORTFOLIO_NAME, PORTFOLIO_CATEGORY, PORTFOLIO_CATEGORY_NAME, PORTFOLIO_CCY, ASSET_GROUP, ASSET_GROUP_NAME, ASSET_CLASS, ASSET_NAME, TRANS_ID, TRANS_DATE, CURRENCY, TRANS_CODE, TRANS_NAME, INFLOW_OUTFLOW, MATURITY_DATE, NOOF_DAYS, COUPON_RATE, NET_AMOUNT_TCY, NET_AMOUNT_PCY, TOT_INTEREST_TCY, TOT_INTEREST_PCY, ACCR_INT_TCY, ACCR_INT_PCY, MATURITY_AMT_TCY, MATURITY_AMT_PCY, MATURITY_REFERENCE, NET_ASSET_VALUE, PER_NAV, ENTRY_DATE, TRANS_REF, TRANS_BASE_REF, TRANS_SRL_NO, COUNTERPARTY, COUNTERPARTY_NAME, CPARTY_GROUP, CPARTY_GROUP_NAME, IS_CPARTY_RELATED, IS_MATURED, MATURITY_DAYS, IS_SYSGEN, REMARKS, BUSINESS_DATE, DATA_SOURCE, TIME_STAMP) AS 
  select  'REPODEAL' as module_ref, repodeal.amc_code as company, 'AMC' as division, repodeal.scheme as portfolio, scheme.SCHEME_name as portfolio_name, scheme.port_type as portfolio_category,
        scheme.port_type as portfolio_category_name, scheme.currency as portfolio_ccy, ASSETGROUP.asset_group, assetgroup.ASSET_GROUP_NAME as asset_group_name,
        assetype.asset_type as asset_class, assetype.DESC1 as asset_name, repodeal.deal_id as trans_id, repodeal.value_date as trans_date, repodeal.currency,
        repodeal.tran_type as trans_code, trantype.name as trans_name, decode(trantype.pur_sal, 'P', 'I', 'O') as inflow_outflow, repodeal.mat_date as maturity_date,
        repodeal.noofdays as noof_days, repodeal.repo_rate as coupon_rate, repodeal.fcy_nett_val as net_amount_tcy, repodeal.nett_val as net_amount_pcy,
        repodeal.fcy_int_recble as tot_interest_tcy, repodeal.int_recble as tot_interest_pcy, repodeal.fcy_accr_int as accr_int_tcy, repodeal.accr_int as accr_int_pcy,
        decode(repotxns.deal_id, null, (repodeal.fcy_nett_val+repodeal.fcy_int_recble), repodeal.fcy_nett_val) as maturity_amt_tcy,
        decode(repotxns.deal_id, null, (repodeal.nett_val+repodeal.int_recble), repodeal.nett_val) as maturity_amt_pcy, repotxns.deal_id as maturity_reference,
        scheme.nav as net_asset_value, decode(scheme.nav, 0, 0, repodeal.nett_val/scheme.nav*100) as per_nav, repodeal.book_date as entry_date, repodeal.app_refer as trans_ref,
        null as trans_base_ref, 1 as trans_srl_no, repodeal.cparty_id as counterparty, cparty.name as counterparty_name, cparty.coup_type as cparty_group,
        cparty.coup_type as cparty_group_name, nvl(cparty.related_yn, 'N') as is_cparty_related, case when repodeal.mat_date < scheme.cur_date then 'Y' else 'N' end as is_matured,
       (repodeal.mat_date - scheme.cur_date) as maturity_days, repodeal.sysgen_y_n as is_sysgen, repodeal.remarks,
        scheme.cur_date as business_date, 'HEXGENDBDATA' as data_source, current_timestamp as time_stamp
from    sysparam,HM_SCHEME scheme,HI_REPO_DEAL_CURR repodeal, HM_ASSET_TYPE assetype, HM_TRAN_TYPE trantype,HM_CPARTY cparty,HI_REPO_TXNS_CURR repotxns ,
HM_ASSET_GROUP ASSETGROUP
where   sysparam.amc_code     = scheme.amc_code
AND assetype.DESC2     = ASSETGROUP.ASSET_GROUP
and     sysparam.amc_code     = repodeal.amc_code
and     scheme.scheme         = repodeal.scheme
and     repodeal.value_date   > scheme.prv_yrend
and     trantype.tran_type    = repodeal.tran_type
and     assetype.asset_type   = repodeal.repo_asset_type
and     cparty.cparty_id      = repodeal.cparty_id
/*
and     sysparam.rectype      = 'L'
and     scheme.rectype        = 'L'
and     repodeal.rectype      = 'L'
and     assetype.rectype      = 'L'
and     trantype.rectype      = 'L'
and     cparty.rectype        = 'L'
*/
and     repotxns.amc_code  (+)= repodeal.amc_code
and     repotxns.scheme    (+)= repodeal.scheme
and     repotxns.app_refer (+)= repodeal.deal_id;
 

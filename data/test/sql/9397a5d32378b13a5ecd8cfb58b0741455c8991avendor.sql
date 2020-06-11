
SELECT dropIfExists('VIEW', 'vendor', 'api');
CREATE OR REPLACE VIEW api.vendor AS
 
SELECT 
  vend_number::varchar AS vendor_number,
  vendtype_code AS vendor_type,
  vend_name AS vendor_name,
  vend_active AS active,
  vend_accntnum AS account_number,
  addr_number AS address_number,
  addr_line1 AS address1,
  addr_line2 AS address2,
  addr_line3 AS address3,
  addr_city AS city,
  addr_state AS state,
  addr_postalcode AS postalcode,
  addr_country AS country,
  (''::TEXT) AS address_change,
  terms_code AS default_terms,
  vend_shipvia AS ship_via,
  curr_abbr AS default_currency,
  CASE 
    WHEN vend_fobsource='W' THEN
     'Receiving Site'
    ELSE
     vend_fob
  END AS default_fob,
  vend_po AS sells_purchase_order_items,
  vend_restrictpurch AS may_only_sell_item_source,
  vend_qualified AS qualified,
  vend_match AS matching_vo_po_amounts,
  vend_1099 AS receives_1099,
  taxzone_code AS default_tax_zone,
  CASE WHEN (accnt_id IS NULL) THEN 'N/A'
       ELSE formatGLAccount(accnt_id)
  END AS default_dist_gl_account,
  CASE WHEN (expcat_id IS NULL) THEN 'N/A'
       ELSE expcat_code
  END AS default_dist_expense_category,
  CASE WHEN (tax_id IS NULL) THEN 'N/A'
       ELSE tax_code
  END AS default_dist_tax_code,
  c1.cntct_number AS contact1_number,
  c1.cntct_honorific AS contact1_honorific,
  c1.cntct_first_name AS contact1_first,
  c1.cntct_middle AS contact1_middle,   
  c1.cntct_last_name AS contact1_last,
  c1.cntct_suffix AS contact1_suffix,
  c1.cntct_title AS contact1_job_title,
  c1.cntct_phone AS contact1_voice,
  c1.cntct_phone2 AS contact1_alternate,
  c1.cntct_fax AS contact1_fax,
  c1.cntct_email AS contact1_email,
  c1.cntct_webaddr AS contact1_web,
  (''::TEXT) AS contact1_change,
  c2.cntct_number AS contact2_number,
  c2.cntct_honorific AS contact2_honorific,
  c2.cntct_first_name AS contact2_first,
  c2.cntct_middle AS contact2_middle,
  c2.cntct_last_name AS contact2_last,
  c2.cntct_suffix AS contact2_suffix,
  c2.cntct_title AS contact2_job_title,
  c2.cntct_phone AS contact2_voice,
  c2.cntct_phone2 AS contact2_alternate,
  c2.cntct_fax AS contact2_fax,
  c2.cntct_email AS contact2_email,
  c2.cntct_webaddr AS contact2_web,
  (''::TEXT) AS contact2_change,
  vend_comments AS notes,
  vend_pocomments AS po_comments,
  vend_emailpodelivery AS allow_email_po_delivery,
  vend_ediemail AS po_edi_email,
  vend_edicc AS po_edi_cc,
  vend_edisubject AS po_edi_subject,
  vend_edifilename AS po_edi_filename,
  vend_ediemailbody AS po_edi_emailbody
FROM
  vendinfo
    LEFT OUTER JOIN addr ON (vend_addr_id=addr_id)
    LEFT OUTER JOIN cntct c1 ON (vend_cntct1_id=c1.cntct_id)
    LEFT OUTER JOIN cntct c2 ON (vend_cntct2_id=c2.cntct_id)
    LEFT OUTER JOIN taxzone ON (vend_taxzone_id=taxzone_id)
    LEFT OUTER JOIN curr_symbol ON (vend_curr_id=curr_id)
    LEFT OUTER JOIN terms ON (vend_terms_id=terms_id)
    LEFT OUTER JOIN vendtype ON (vend_vendtype_id=vendtype_id)
    LEFT OUTER JOIN accnt ON (vend_accnt_id=accnt_id)
    LEFT OUTER JOIN expcat ON (vend_expcat_id=expcat_id)
    LEFT OUTER JOIN tax ON (vend_tax_id=tax_id)
ORDER BY vend_number;

GRANT ALL ON TABLE api.vendor TO xtrole;
COMMENT ON VIEW api.vendor IS 'vendor';

--Rules

CREATE OR REPLACE RULE "_INSERT" AS
    ON INSERT TO api.vendor DO INSTEAD

INSERT INTO vendinfo (
  vend_name,
  vend_lastpurchdate,
  vend_active,
  vend_po,
  vend_comments,
  vend_pocomments,
  vend_number,
  vend_1099,
  vend_exported,
  vend_fobsource,
  vend_fob,
  vend_terms_id,
  vend_shipvia,
  vend_vendtype_id,
  vend_qualified,
  vend_ediemail,
  vend_ediemailbody,
  vend_edisubject,
  vend_edifilename,
  vend_accntnum,
  vend_emailpodelivery,
  vend_restrictpurch,
  vend_edicc,
  vend_curr_id,
  vend_cntct1_id,
  vend_cntct2_id,
  vend_addr_id,
  vend_match,
  vend_taxzone_id,
  vend_ach_routingnumber,
  vend_ach_accntnumber,
  vend_accnt_id,
  vend_expcat_id,
  vend_tax_id )
VALUES (
  COALESCE(NEW.vendor_name, ''),
  NULL,
  COALESCE(NEW.active, true),
  COALESCE(NEW.sells_purchase_order_items, false),
  COALESCE(NEW.notes, ''),
  COALESCE(NEW.po_comments, ''),
  COALESCE(NEW.vendor_number, ''),
  COALESCE(NEW.receives_1099, false),
  false,
  CASE 
    WHEN NEW.default_fob='Receiving Site' THEN
     'W'
    ELSE
     'V'
  END,
  CASE 
    WHEN NEW.default_fob='Receiving Site' THEN
     ''
    ELSE
     NEW.default_fob
  END,
  COALESCE(getTermsId(NEW.default_terms), FetchMetricValue('DefaultTerms')),
  COALESCE(NEW.ship_via, FetchDefaultShipVia()),
  getVendtypeId(NEW.vendor_type),
  COALESCE(NEW.qualified, false),
  COALESCE(NEW.po_edi_email, ''),
  COALESCE(NEW.po_edi_emailbody, ''),
  COALESCE(NEW.po_edi_subject, ''),
  COALESCE(NEW.po_edi_filename, ''),
  COALESCE(NEW.account_number, ''),
  COALESCE(NEW.allow_email_po_delivery, false),
  COALESCE(NEW.may_only_sell_item_source, false),
  COALESCE(NEW.po_edi_cc, ''),
  COALESCE(getCurrId(NEW.default_currency), basecurrid()),
  saveCntct( getCntctId(NEW.contact1_number),
             NEW.contact1_number,
             NULL,
             NEW.contact1_honorific,
             NEW.contact1_first,
             NEW.contact1_middle,
             NEW.contact1_last,
             NEW.contact1_suffix,
             NEW.contact1_voice,
             NEW.contact1_alternate,
             NEW.contact1_fax,
             NEW.contact1_email,
             NEW.contact1_web,
             NEW.contact1_job_title,
             NEW.contact1_change ),
  saveCntct( getCntctId(NEW.contact2_number),
             NEW.contact2_number,
             NULL,
             NEW.contact2_honorific,
             NEW.contact2_first,
             NEW.contact2_middle,
             NEW.contact2_last,
             NEW.contact2_suffix,
             NEW.contact2_voice,
             NEW.contact2_alternate,
             NEW.contact2_fax,
             NEW.contact2_email,
             NEW.contact2_web,
             NEW.contact2_job_title,
             NEW.contact2_change ),
  saveAddr( getAddrId(NEW.address_number),
            NEW.address_number,
            NEW.address1,
            NEW.address2,
            NEW.address3,
            NEW.city,
            NEW.state,
            NEW.postalcode,
            NEW.country,
            NEW.address_change ),
  COALESCE(NEW.matching_vo_po_amounts, false),
  getTaxZoneId(NEW.default_tax_zone),
            '',
            '',
  COALESCE(getGLAccntId(NEW.default_dist_gl_account), -1),
  COALESCE(getExpCatId(NEW.default_dist_expense_category), -1),
  COALESCE(getTaxId(NEW.default_dist_tax_code), -1)
);

CREATE OR REPLACE RULE "_UPDATE" AS
    ON UPDATE TO api.vendor DO INSTEAD

UPDATE vendinfo SET
  vend_name=NEW.vendor_name,
  vend_active=NEW.active,
  vend_po=NEW.sells_purchase_order_items,
  vend_comments=NEW.notes,
  vend_pocomments=NEW.po_comments,
  vend_1099=NEW.receives_1099,
  vend_fobsource = CASE 
                     WHEN NEW.default_fob IS NULL THEN
                       NULL
                     WHEN NEW.default_fob='Receiving Site' THEN
                       'W'
                     ELSE
                       'V'
                   END,
  vend_fob       = CASE 
                     WHEN NEW.default_fob IS NULL THEN
                       NULL
                     WHEN NEW.default_fob='Receiving Site' THEN
                       ''
                     ELSE
                       NEW.default_fob
                   END,
  vend_terms_id=getTermsId(NEW.default_terms),
  vend_shipvia=NEW.ship_via,
  vend_vendtype_id=getVendtypeId(NEW.vendor_type),
  vend_qualified=NEW.qualified,
  vend_ediemail=NEW.po_edi_email,
  vend_ediemailbody=NEW.po_edi_emailbody,
  vend_edisubject=NEW.po_edi_subject,
  vend_edifilename=NEW.po_edi_filename,
  vend_accntnum=NEW.account_number,
  vend_emailpodelivery=NEW.allow_email_po_delivery,
  vend_restrictpurch=NEW.may_only_sell_item_source,
  vend_edicc=NEW.po_edi_cc,
  vend_curr_id=getCurrId(NEW.default_currency),
  vend_cntct1_id=
  saveCntct( getCntctId(NEW.contact1_number),
             NEW.contact1_number,
             NULL,
             NEW.contact1_honorific,
             NEW.contact1_first,
             NEW.contact1_middle,
             NEW.contact1_last,
             NEW.contact1_suffix,
             NEW.contact1_voice,
             NEW.contact1_alternate,
             NEW.contact1_fax,
             NEW.contact1_email,
             NEW.contact1_web,
             NEW.contact1_job_title,
             NEW.contact1_change ),
  vend_cntct2_id=
  saveCntct( getCntctId(NEW.contact2_number),
             NEW.contact2_number,
             NULL,
             NEW.contact2_honorific,
             NEW.contact2_first,
             NEW.contact2_middle,
             NEW.contact2_last,
             NEW.contact2_suffix,
             NEW.contact2_voice,
             NEW.contact2_alternate,
             NEW.contact2_fax,
             NEW.contact2_email,
             NEW.contact2_web,
             NEW.contact2_job_title,
             NEW.contact2_change ),
  vend_addr_id=
  saveAddr( getAddrId(NEW.address_number),
            NEW.address_number,
            NEW.address1,
            NEW.address2,
            NEW.address3,
            NEW.city,
            NEW.state,
            NEW.postalcode,
            NEW.country,
            NEW.address_change ),
  vend_match=NEW.matching_vo_po_amounts,
  vend_taxzone_id=getTaxZoneId(NEW.default_tax_zone),
  vend_accnt_id=COALESCE(getGLAccntId(NULLIF(NEW.default_dist_gl_account, 'N/A')), -1),
  vend_expcat_id=COALESCE(getExpCatId(NULLIF(NEW.default_dist_expense_category, 'N/A')), -1),
  vend_tax_id=COALESCE(getTaxId(NULLIF(NEW.default_dist_tax_code, 'N/A')), -1)
WHERE vend_id=getVendId(OLD.vendor_number);

CREATE OR REPLACE RULE "_DELETE" AS
    ON DELETE TO api.vendor DO INSTEAD
    DELETE FROM public.vendinfo WHERE (vend_number=OLD.vendor_number);


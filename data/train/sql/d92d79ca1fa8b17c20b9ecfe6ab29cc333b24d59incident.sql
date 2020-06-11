-- Incident View

SELECT dropIfExists('VIEW', 'incident', 'api');
CREATE OR REPLACE VIEW api.incident AS
  SELECT
    incdt_number AS incident_number,
    incdtcat_name AS category,
    incdt_summary AS description,
    crmacct_number AS crm_account,
    incdt_assigned_username AS assigned_to,
    CASE
      WHEN incdt_status='N' THEN
        'New'
      WHEN incdt_status='F' THEN
        'Feedback'
      WHEN incdt_status='C' THEN
        'Confirmed'
      WHEN incdt_status='A' THEN
        'Assigned'
      WHEN incdt_status='R' THEN
        'Resolved'
      WHEN incdt_status='L' THEN
        'Closed'
      ELSE
        '?'
    END AS status,
    incdtseverity_name AS severity,
    incdtpriority_name AS priority,
    incdtresolution_name AS resolution,
    cntct_number AS contact_number,
    cntct_honorific AS honorific,
    cntct_first_name AS first,
    cntct_middle AS middle,
    cntct_last_name AS last,
    cntct_suffix AS suffix,
    cntct_title AS job_title,
    cntct_phone AS phone,
    cntct_fax AS fax,
    cntct_email AS email,
    (''::TEXT) AS contact_change,
    incdt_descrip AS notes,
    item_number AS item_number,
    incdt_lotserial AS lot_serial_number,
    CASE
      WHEN aropen_doctype='C' THEN
        'C/M'
      WHEN aropen_doctype='D' THEN
        'D/M'
      WHEN aropen_doctype='I' THEN
        'Invoice'
      WHEN aropen_doctype='R' THEN
        'C/D'
      ELSE
        ''
    END AS ar_doc_type,
    aropen_docnumber AS ar_doc_number
  FROM incdt
     LEFT OUTER JOIN incdtcat ON (incdtcat_id=incdt_incdtcat_id)
     LEFT OUTER JOIN crmacct ON (crmacct_id=incdt_crmacct_id)
     LEFT OUTER JOIN incdtseverity ON (incdtseverity_id=incdt_incdtseverity_id)
     LEFT OUTER JOIN incdtpriority ON (incdtpriority_id=incdt_incdtpriority_id)
     LEFT OUTER JOIN incdtresolution ON (incdtresolution_id=incdt_incdtresolution_id)
     LEFT OUTER JOIN cntct ON (cntct_id=incdt_cntct_id)
     LEFT OUTER JOIN item ON (item_id=incdt_item_id)
     LEFT OUTER JOIN aropen ON (aropen_id=incdt_aropen_id);

GRANT ALL ON TABLE api.incident TO xtrole;
COMMENT ON VIEW api.incident IS 'Incident';

--Rules

CREATE OR REPLACE RULE "_INSERT" AS
    ON INSERT TO api.incident DO INSTEAD

  INSERT INTO incdt (
    incdt_number,
    incdt_crmacct_id,
    incdt_cntct_id,
    incdt_summary,
    incdt_descrip,
    incdt_item_id,
    incdt_status,
    incdt_assigned_username,
    incdt_incdtcat_id,
    incdt_incdtseverity_id,
    incdt_incdtpriority_id,
    incdt_incdtresolution_id,
    incdt_lotserial,
    incdt_ls_id
    )
  VALUES (
    NEW.incident_number,
    getCrmAcctId(NEW.crm_account),
    saveCntct(
      getCntctId(NEW.contact_number),
      NEW.contact_number,
      NULL,
      NEW.honorific,
      NEW.first,
      NEW.middle,
      NEW.last,
      NEW.suffix,
      NEW.phone,
      NULL,
      NEW.fax,
      NEW.email,
      NULL,
      NEW.job_title,
      NEW.contact_change),
    COALESCE(NEW.description, ''),
    COALESCE(NEW.notes, ''),
    getItemId(NEW.item_number),
    CASE
      WHEN NEW.status='New' THEN
        'N'
      WHEN NEW.status='Feedback' THEN
        'F'
      WHEN NEW.status='Confirmed' THEN
        'C'
      WHEN NEW.status='Assigned' THEN
        'A'
      WHEN NEW.status='Resolved' THEN
        'R'
      WHEN NEW.status='Closed' THEN
        'L'
      ELSE
        ''
    END,
    COALESCE(NEW.assigned_to, ''),
    getIncdtCatId(NEW.category),
    getIncdtSeverityId(NEW.severity),
    getIncdtPriorityId(NEW.priority),
    getIncdtResolutionId(NEW.resolution),
    COALESCE(NEW.lot_serial_number, ''),
    getLotSerialId(NEW.item_number, NEW.lot_serial_number)
    );

CREATE OR REPLACE RULE "_UPDATE" AS 
    ON UPDATE TO api.incident DO INSTEAD

  UPDATE incdt SET
    incdt_crmacct_id=getCrmAcctId(NEW.crm_account),
    incdt_cntct_id=
     saveCntct(
      getCntctId(NEW.contact_number),
      NEW.contact_number,
      NULL,
      NEW.honorific,
      NEW.first,
      NEW.middle,
      NEW.last,
      NEW.suffix,
      NEW.phone,
      NULL,
      NEW.fax,
      NEW.email,
      NULL,
      NEW.job_title,
      NEW.contact_change),
    incdt_descrip=NEW.notes,
    incdt_summary=NEW.description,
    incdt_item_id=getItemId(NEW.item_number),
    incdt_status=
      CASE
        WHEN NEW.status='New' THEN
          'N'
        WHEN NEW.status='Feedback' THEN
          'F'
        WHEN NEW.status='Confirmed' THEN
          'C'
        WHEN NEW.status='Assigned' THEN
          'A'
        WHEN NEW.status='Resolved' THEN
          'R'
        WHEN NEW.status='Closed' THEN
          'L'
        ELSE
          NULL
      END,
    incdt_assigned_username=NEW.assigned_to,
    incdt_incdtcat_id=getIncdtCatId(NEW.category),
    incdt_incdtseverity_id=getIncdtSeverityId(NEW.severity),
    incdt_incdtpriority_id=getIncdtPriorityId(NEW.priority),
    incdt_incdtresolution_id=getIncdtResolutionId(NEW.resolution),
    incdt_lotserial=NEW.lot_serial_number,
    incdt_ls_id=getLotSerialId(NEW.item_number, NEW.lot_serial_number)
  WHERE (incdt_id=getIncidentId(OLD.incident_number));
           
CREATE OR REPLACE RULE "_DELETE" AS 
    ON DELETE TO api.incident DO INSTEAD

  NOTHING;

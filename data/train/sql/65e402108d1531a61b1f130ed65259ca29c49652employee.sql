
  SELECT dropIfExists('VIEW', 'employee', 'api');

  CREATE OR REPLACE VIEW api.employee AS 
 
  SELECT 
    e.emp_code::varchar		AS code, 
    e.emp_number::varchar 	AS number, 
    e.emp_active 		AS active, 
    e.emp_startdate 		AS start_date, 
    cntct.cntct_number 	AS contact_number, 
    cntct.cntct_honorific 	AS honorific, 
    cntct.cntct_first_name 	AS first, 
    cntct.cntct_middle 	AS middle, 
    cntct.cntct_last_name 	AS last, 
    cntct.cntct_suffix 	AS suffix, 
    cntct.cntct_title 		AS job_title, 
    cntct.cntct_phone 		AS voice, 
    cntct.cntct_phone2 	AS alternate, 
    cntct.cntct_fax 		AS fax, 
    cntct.cntct_email 		AS email, 
    cntct.cntct_webaddr 	AS web, 
    (''::TEXT) 			AS contact_change, 
    addr.addr_number 		AS address_number, 
    addr.addr_line1 		AS address1, 
    addr.addr_line2 		AS address2, 
    addr.addr_line3 		AS address3, 
    addr.addr_city 			AS city, 
    addr.addr_state 		AS state, 
    addr.addr_postalcode 	AS postalcode, 
    addr.addr_country 		AS country, 
    (''::TEXT) 				AS address_change, 
    whsinfo.warehous_code 	AS site, 
    m.emp_code 				AS manager_code, 
    
    CASE WHEN (e.emp_wage_type = 'H')		THEN 'Hourly'
         WHEN (e.emp_wage_type = 'S')		THEN 'Salaried'
         WHEN e.emp_wage_type IS NULL THEN NULL
		 ELSE 'Error'
    END AS wage_type, 
    e.emp_wage 	AS wage, 
    curr_symbol.curr_abbr AS wage_currency, 
    CASE WHEN (e.emp_wage_period = 'H') 	THEN 'Hour'
         WHEN (e.emp_wage_period = 'D') 	THEN 'Day'
         WHEN (e.emp_wage_period = 'W') 	THEN 'Week'
         WHEN (e.emp_wage_period = 'BW') 	THEN 'Biweek'
         WHEN (e.emp_wage_period = 'M') 	THEN 'Month'
         WHEN (e.emp_wage_period = 'Y') 	THEN 'Year'
         WHEN (e.emp_wage_period IS NULL) 	THEN NULL
         ELSE 'Error'
    END AS wage_period, 
    dept.dept_number AS department, 
    shift.shift_number AS shift, 
    crmacct_usr_username IS NOT NULL AS is_user,
    salesrep.salesrep_id IS NOT NULL AS is_salesrep,
    vendinfo.vend_id IS NOT NULL AS is_vendor,
    e.emp_notes AS notes,
    image.image_name AS image,
    e.emp_extrate AS rate,
    curr_symbol.curr_abbr AS billing_currency, 
    CASE WHEN (e.emp_extrate_period = 'H') 	THEN 'Hour'
         WHEN (e.emp_extrate_period = 'D') 	THEN 'Day'
         WHEN (e.emp_extrate_period = 'W') 	THEN 'Week'
         WHEN (e.emp_extrate_period = 'BW') THEN 'Biweek'
         WHEN (e.emp_extrate_period = 'M') 	THEN 'Month'
         WHEN (e.emp_extrate_period = 'Y') 	THEN 'Year'
         WHEN (e.emp_extrate_period IS NULL) THEN NULL
         ELSE 'Error'
   	END AS billing_period
  FROM emp e
         JOIN crmacct           ON (e.emp_id = crmacct_emp_id)
   	 LEFT JOIN cntct 	ON (e.emp_cntct_id = cntct.cntct_id)
   	 LEFT JOIN addr 	ON (cntct.cntct_addr_id = addr.addr_id)
   	 LEFT JOIN whsinfo 	ON (e.emp_warehous_id = whsinfo.warehous_id)
   	 LEFT JOIN emp m 	ON (e.emp_mgr_emp_id = m.emp_id)
   	 LEFT JOIN dept 	ON (e.emp_dept_id = dept.dept_id)
   	 LEFT JOIN shift 	ON (e.emp_shift_id = shift.shift_id)
   	 LEFT JOIN salesrep     ON (crmacct_salesrep_id = salesrep_id)
   	 LEFT JOIN vendinfo     ON (crmacct_vend_id = vend_id)
   	 LEFT JOIN image 	ON (e.emp_image_id = image.image_id)
   	 JOIN curr_symbol 	ON (e.emp_wage_curr_id = curr_symbol.curr_id);

ALTER TABLE api.employee OWNER TO "admin";
GRANT ALL ON TABLE api.employee TO "admin";
GRANT ALL ON TABLE api.employee TO xtrole;
COMMENT ON VIEW api.employee IS 'Employee';

--Rules

CREATE OR REPLACE RULE "_INSERT" AS ON INSERT TO api.employee DO INSTEAD  
  INSERT INTO emp (
      emp_code, 
      emp_number, 
      emp_active, 
      emp_cntct_id, 
      emp_warehous_id, 
      emp_mgr_emp_id, 
      emp_wage_type, 
      emp_wage, 
      emp_wage_curr_id,
      emp_wage_period,
      emp_dept_id,
      emp_shift_id,
      emp_image_id,
      emp_extrate, 
      emp_extrate_period,
      emp_startdate, 
      emp_notes
    ) VALUES (
      new.code,
      new.number,
      COALESCE(new.active, true), 
      savecntct(getcntctid(new.contact_number),
      			new.contact_number,
				saveaddr(getaddrid(new.address_number),
      					 new.address_number,
      					 new.address1,
      					 new.address2,
      					 new.address3,
      					 new.city,
      					 new.state,
      					 new.postalcode,
      					 new.country,
      					 new.address_change),
      			new.honorific, 
		      	new.first,
      			new.middle,
      			new.last,
      			new.suffix,
      			new.voice,
      			new.alternate,
      			new.fax,
      			new.email,
      			new.web,
      			new.job_title,
      			new.contact_change
      ), 
      getwarehousid(new.site, 'ALL'),
      (SELECT emp.emp_id FROM emp WHERE (emp.emp_code = new.manager_code)), 
      CASE WHEN new.wage_type = 'Hourly' THEN 'H'
           WHEN new.wage_type = 'Salaried' THEN 'S'
           ELSE NULL
      END, 
      new.wage, 
      COALESCE(getcurrid(new.wage_currency), basecurrid()), 
      CASE WHEN new.wage_period = 'Hour' 	THEN 'H'
           WHEN new.wage_period = 'Day' 	THEN 'D'
           WHEN new.wage_period = 'Week' 	THEN 'W'
           WHEN new.wage_period = 'Biweek' 	THEN 'BW'
           WHEN new.wage_period = 'Month' 	THEN 'M'
           WHEN new.wage_period = 'Year' 	THEN 'Y'
           ELSE NULL
        END, 
        getdeptid(new.department), 
        getshiftid(new.shift), 
        getimageid(new.image), 
        new.rate, 
        CASE
           WHEN new.billing_period = 'Hour' THEN 'H'
           WHEN new.billing_period = 'Day' 	THEN 'D'
           WHEN new.billing_period = 'Week' THEN 'W'
           WHEN new.billing_period = 'Biweek' THEN 'BW'
           WHEN new.billing_period = 'Month' THEN 'M'
           WHEN new.billing_period = 'Year' THEN 'Y'
           ELSE NULL
        END, 
        new.start_date, 
        COALESCE(new.notes, '')
      );


CREATE OR REPLACE RULE "_UPDATE" AS ON UPDATE TO api.employee DO INSTEAD
  
  UPDATE emp SET 
    emp_code = new.code, 
    emp_number = new.number, 
    emp_active = new.active, 
    emp_startdate = new.start_date, 
    emp_cntct_id = savecntct(getcntctid(new.contact_number), 
								new.contact_number, 
								saveaddr(getaddrid(new.address_number), 
										 new.address_number, 
										 new.address1, 
										 new.address2, 
										 new.address3, 
										 new.city, 
										 new.state, 
										 new.postalcode, 
										 new.country, 
										 new.address_change), 
							 	new.honorific, 
							 	new.first, 
							 	new.middle, 
							 	new.last, 
							 	new.suffix, 
							 	new.voice,
							 	new.alternate,
							 	new.fax,
							 	new.email,
							 	new.web,
							 	new.job_title,
							 	new.contact_change
				), 
	emp_warehous_id = getwarehousid(new.site, 'ALL'),
	emp_mgr_emp_id = ( SELECT emp.emp_id FROM emp WHERE emp.emp_code = new.manager_code), 
	emp_wage_type = CASE WHEN new.wage_type = 'Hourly' 	 THEN 'H'
            			 WHEN new.wage_type = 'Salaried' THEN 'S'
            			 ELSE NULL
        			END, 
    emp_wage = new.wage, 
    emp_wage_curr_id = COALESCE(getcurrid(new.wage_currency), basecurrid()), 
    emp_wage_period = CASE 	WHEN new.wage_period = 'Hour' THEN 'H'
    					   	WHEN new.wage_period = 'Day' THEN 'D'
            				WHEN new.wage_period = 'Week' THEN 'W'
				            WHEN new.wage_period = 'Biweek' THEN 'BW'
            				WHEN new.wage_period = 'Month' THEN 'M'
				            WHEN new.wage_period = 'Year' THEN 'Y'
            				ELSE NULL
				      END, 
	emp_dept_id = getdeptid(new.department), 
	emp_shift_id = getshiftid(new.shift), 
	emp_image_id = getimageid(new.image), 
	emp_extrate = new.rate, 
	emp_extrate_period = CASE WHEN new.billing_period = 'Hour' 	THEN 'H'
            				  WHEN new.billing_period = 'Day' 	THEN 'D'
                              WHEN new.billing_period = 'Week' 	THEN 'W'
				              WHEN new.billing_period = 'Biweek' THEN 'BW'
				              WHEN new.billing_period = 'Month' THEN 'M'
				              WHEN new.billing_period = 'Year' 	THEN 'Y'
            				  ELSE NULL
        				 END, 
	emp_notes = COALESCE(new.notes, '')
  WHERE emp.emp_code = old.code;


CREATE OR REPLACE RULE "_DELETE" AS ON DELETE TO api.employee DO INSTEAD  
    DELETE FROM emp WHERE (emp_code=old.code::text);


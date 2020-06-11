<%--
/**
 * Developed by Altum, Inc.
 * 11718 Bowman Green Drive, Reston, VA 20190 USA
 * Copyright (c) 2000-2009 Altum, Inc.
 * All rights reserved.
 */ --%>
<%

/******************************************************************************/
// select statement
StringBuffer sbSelect = new StringBuffer();
sbSelect.append("select '<a href=\"javascript:openProjectCodingReport('||appl_id||',false);\" >'||appl_id||'</a> ' AS appl_id ");
sbSelect.append(", '<a href=\"javascript:openProjectCodingReport('||serial_num||',true);\" >'||serial_num||'</a> ' AS serial_num");
sbSelect.append(", fy ");
sbSelect.append(", proj_num ");
sbSelect.append(", proj_title ");
sbSelect.append(", org_name ");
sbSelect.append(", city_name || '/' || state as city_state ");
sbSelect.append(", pi_name ");
sbSelect.append(", po_name ");
sbSelect.append(", cancer_activity_description as cancer_act ");
sbSelect.append(", pd_division_abbreviation  as division ");
sbSelect.append(", project_period_start_date ");
sbSelect.append(", project_period_end_date ");
sbSelect.append(", coalesce(obligated_nci_amt,0) as amount_oblig ");
sbSelect.append(", type ");
sbSelect.append(", code ");
sbSelect.append(", code_name ");
sbSelect.append(", code_percent_relevance ");
sbSelect.append(", getrcdccodelist(fy,appl_id, ',') as rcdc_code_list ");
sbSelect.append("from rcdc_appls_admin_info ");
sbSelect.append("left outer join raeb_project_codes using (appl_id) ");
sbSelect.append("left outer join rcdc_nci_appls_admin_info using (appl_id) ");
sbSelect.append("where appl_id in (");
if(bRunByApplID){
	sbSelect.append(applIDOrSerial);
}else{
	sbSelect.append("select distinct appl_id from rcdc_appls_admin_info where serial_num in (").append(applIDOrSerial).append(")");
}
sbSelect.append(") ");
sbSelect.append("order by fy desc, appl_id, type desc, code_name asc ");

String sSelect = sbSelect.toString();
%>
<%= "<" + "!-- Report sql:  " + sSelect + "-->" %>



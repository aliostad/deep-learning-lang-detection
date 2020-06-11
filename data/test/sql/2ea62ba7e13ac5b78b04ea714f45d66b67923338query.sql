SELECT
	a.tuid
	,a.subject_id
	,a.document_type
	,a.action_type
	,a.document_name
	,a.table_id
	,a.form_id
	,a.report_id
	,a.remark
	,a.nav_url
	,a.nav_url_width
	,t.table_name
	,f.form_name_${def:locale} as form_name
	,r.report_name_${def:locale} as report_name
	,a.url
	,a.nav_url_bottom
	,a.nav_bottom_hight
	,a.nav_url_right
	,a.nav_right_width
	,a.nav_url_top
	,a.nav_url_hight
	,a.doc_width
	,a.doc_hight
FROM
	t_document a
	left join t_table t on a.table_id = t.tuid
	left join t_form f on a.form_id = f.tuid
	left join t_report r on a.report_id = r.tuid
WHERE
	a.tuid=${fld:id}

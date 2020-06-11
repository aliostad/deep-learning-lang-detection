INSERT	INTO
t_form_show_field
(
	tuid, form_id, field_id, show_order, created, createdby, updated, 
       updatedby,  width, show_type, show_color, colspan, 
       rowspan, item_id, is_mandatory, is_readonly, is_cascade_combo
)
SELECT ${seq:nextval@${schema}seq_default}, ${form_id}, field_id, show_order, created, createdby, updated, 
       updatedby,  width, show_type, show_color, colspan, 
       rowspan, null, is_mandatory, is_readonly, is_cascade_combo
FROM 
	t_form_show_field
where
	form_id = ${fld:form_id}
and
	item_id is null
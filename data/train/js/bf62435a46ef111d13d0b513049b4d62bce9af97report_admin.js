//edit report elements functions
function showElementConfigOptions(type){
	switch(type){
		case 'report.lib.ChartCategory': 
		case 'report.lib.ChartData': 
			hideElementConfigOptions();
			break;
		case 'InputText': 
		case 'Listbox': 
		case 'Checkbox':
		case 'Radio':
		case 'InputDate':
		case 'AutoSuggest':
			hideElementConfigOptions();
			$('fld_attr_selfrom_container').show();
			break;			
		default:
			hideElementConfigOptions();
			$('fld_attr_font_width_container').show();	
			$('fld_attr_font_height_container').show();
			$('fld_attr_font_weight_container').show();	
			$('fld_attr_font_style_container').show();
			$('fld_attr_text_decoration_container').show();
			$('fld_attr_align_container').show();
			$('fld_attr_font_size_container').show();
			$('fld_attr_color_container').show();
			$('fld_attr_bgcolor_container').show();
			
			break;
	}
}

function hideElementConfigOptions(){
	$('fld_attr_font_width_container').hide();	
	$('fld_attr_font_height_container').hide();
	$('fld_attr_font_weight_container').hide();	
	$('fld_attr_font_style_container').hide();
	$('fld_attr_text_decoration_container').hide();
	$('fld_attr_align_container').hide();
	$('fld_attr_font_size_container').hide();
	$('fld_attr_color_container').hide();
	$('fld_attr_bgcolor_container').hide();
	$('fld_attr_selfrom_container').hide();
}

//edit report form functions
function showConfigOptions(type){
	switch(type){
		case 'chart':
			hideConfigOptions();
			$('fld_subtype_container').show();
			$('fld_width_container').show();
			$('fld_height_container').show();
			$('fld_show_hover_cap_container').show();
			$('fld_show_label_container').show();
			$('fld_show_value_container').show();
			$('fld_show_number_prefix_container').show();
			$('fld_show_number_suffix_container').show();
			$('fld_show_format_number_container').show();
			$('fld_show_number_scale_container').show();
			showSubConfigOptions($('fld_subtype').value);
			break;
			
		case 'table':
			hideConfigOptions();			
			$('fld_template_container').show();
			$('fld_pagesize_container').show();
			break;

		case 'filter':
			hideConfigOptions();
	}	
}

function showSubConfigOptions(type){
	hideConfigOptions();
	$('fld_subtype_container').show();
	
	$('fld_width_container').show();
	$('fld_height_container').show();
	$('fld_show_hover_cap_container').show();
	$('fld_show_label_container').show();
	$('fld_show_value_container').show();
	$('fld_show_number_prefix_container').show();
	$('fld_show_number_suffix_container').show();
	$('fld_show_format_number_container').show();
	$('fld_show_number_scale_container').show();	
	switch(type){
		case 'StackedColumn2D':
		case 'MSColumn2D':
			$('fld_show_legend_container').show();
		case 'Column2D':
			$('fld_show_limits_container').show();
			$('fld_show_rotate_name_container').show();
			$('fld_y_min_value_container').show();
			$('fld_y_max_value_container').show();
			$('fld_show_column_shadow_container').show();
			$('fld_show_animation_container').show();
			break;

		case 'StackedColumn3D':			
		case 'MSColumn3D':
			$('fld_show_legend_container').show();			
		case 'Column3D':
			$('fld_show_limits_container').show();
			$('fld_show_rotate_name_container').show();
			$('fld_y_min_value_container').show();
			$('fld_y_max_value_container').show();
			$('fld_show_animation_container').show();
			break;

		case 'StackedBar2D':
		case 'MSBar2D':
			$('fld_show_legend_container').show();				
		case 'Bar2D':
			$('fld_show_limits_container').show();
			$('fld_show_rotate_name_container').show();
			$('fld_y_min_value_container').show();
			$('fld_y_max_value_container').show();
			$('fld_show_column_shadow_container').show();
			$('fld_show_animation_container').show();
			$('fld_show_bar_shadow_container').show();
			break;

		case 'StackedArea2D':			
		case 'MSArea2D':
			$('fld_show_legend_container').show();				
		case 'Area2D':
			$('fld_show_limits_container').show();
			$('fld_show_rotate_name_container').show();
			$('fld_y_min_value_container').show();
			$('fld_y_max_value_container').show();
			$('fld_show_column_shadow_container').show();
			$('fld_show_animation_container').show();
			$('fld_show_area_border_container').show();
			$('fld_show_area_alpha_container').show();
			break;

		case 'MSLine':
			$('fld_show_legend_container').show();				
		case 'Line':
			$('fld_show_limits_container').show();
			$('fld_show_rotate_name_container').show();
			$('fld_y_min_value_container').show();
			$('fld_y_max_value_container').show();
			$('fld_show_column_shadow_container').show();
			$('fld_show_animation_container').show();
			$('fld_show_anchor_container').show();
			$('fld_show_anchor_radius_container').show();
			break;
		case 'Pie2D':
			$('fld_show_percentage_value_container').show();	
			$('fld_show_percentage_in_label_container').show();
			$('fld_show_shadow_container').show();
			$('fld_show_animation_container').show();
			$('fld_show_pie_radius_container').show();
			break;
		case 'Pie3D':
			$('fld_show_percentage_value_container').show();	
			$('fld_show_percentage_in_label_container').show();
			$('fld_show_pie_radius_container').show();
			$('fld_show_pie_y_scale_container').show();
			$('fld_show_pie_slice_depth_container').show();
			break;
			

	}
}

function hideConfigOptions(){
	$('fld_pagesize_container').hide();	
	$('fld_template_container').hide();	
	$('fld_subtype_container').hide();
	$('fld_width_container').hide();
	$('fld_height_container').hide();
	$('fld_show_label_container').hide();
	$('fld_show_value_container').hide();
	$('fld_show_hover_cap_container').hide();
	$('fld_show_number_prefix_container').hide();
	$('fld_show_number_suffix_container').hide();
	$('fld_show_format_number_container').hide();
	$('fld_show_number_scale_container').hide();		
	$('fld_show_percentage_value_container').hide();	
	$('fld_show_percentage_in_label_container').hide();
	$('fld_show_pie_radius_container').hide();
	$('fld_show_pie_y_scale_container').hide();
	$('fld_show_pie_slice_depth_container').hide();
	$('fld_show_shadow_container').hide();
	$('fld_show_animation_container').hide();
	$('fld_show_limits_container').hide();
	$('fld_show_rotate_name_container').hide();
	$('fld_y_min_value_container').hide();
	$('fld_y_max_value_container').hide();
	$('fld_show_column_shadow_container').hide();
	$('fld_show_anchor_container').hide();
	$('fld_show_anchor_radius_container').hide();
	$('fld_show_bar_shadow_container').hide();
	$('fld_show_area_border_container').hide();
	$('fld_show_area_alpha_container').hide();
	$('fld_show_legend_container').hide();
}
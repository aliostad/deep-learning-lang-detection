<?php

	global $wpdb;
	
	#############################################################################################
	if( $_POST[ 'pppm_hidden' ] == 'pppm_saving' ) {
	
		update_option( 'pppm_save_txt_button_type', intval( $_POST[ 'pppm_save_txt_button_type' ] ));
		update_option( 'pppm_save_txt_button_url', pppm_filter_strip( $_POST[ 'pppm_save_txt_button_url' ] ));
		update_option( 'pppm_save_txt_button_text', pppm_filter_strip( $_POST[ 'pppm_save_txt_button_text' ] ));
		update_option( 'pppm_save_txt_icon_url', pppm_filter_strip( $_POST[ 'pppm_save_txt_icon_url' ] ));
	
		update_option( 'pppm_html_t_title', pppm_filter_strip( $_POST[ 'pppm_html_t_title' ] ));
		update_option( 'pppm_html_t_image', pppm_filter_strip( $_POST[ 'pppm_html_t_image' ] ));
		update_option( 'pppm_html_t_excerpt', pppm_filter_strip( $_POST[ 'pppm_html_t_excerpt' ] ));
		update_option( 'pppm_html_t_date', pppm_filter_strip( $_POST[ 'pppm_html_t_date' ] ));
		update_option( 'pppm_html_t_md', pppm_filter_strip( $_POST[ 'pppm_html_t_md' ] ));
		update_option( 'pppm_save_html_img_max_width', intval( $_POST[ 'pppm_save_html_img_max_width' ] ));
		update_option( 'pppm_save_html_button_type', intval( $_POST[ 'pppm_save_html_button_type' ] ));
		update_option( 'pppm_save_html_button_url', pppm_filter_strip( $_POST[ 'pppm_save_html_button_url' ] ));
		update_option( 'pppm_save_html_button_text', pppm_filter_strip( $_POST[ 'pppm_save_html_button_text' ] ));
		update_option( 'pppm_save_html_icon_url', pppm_filter_strip( $_POST[ 'pppm_save_html_icon_url' ] ));
		update_option( 'pppm_save_html_css', pppm_filter_strip( $_POST[ 'pppm_save_html_css' ] )); //v1.0.4
	
		update_option( 'pppm_doc_t_title', pppm_filter_strip( $_POST[ 'pppm_doc_t_title' ] ));
		update_option( 'pppm_doc_t_image', pppm_filter_strip( $_POST[ 'pppm_doc_t_image' ] ));
		update_option( 'pppm_doc_t_excerpt', pppm_filter_strip( $_POST[ 'pppm_doc_t_excerpt' ] ));
		update_option( 'pppm_doc_t_date', pppm_filter_strip( $_POST[ 'pppm_doc_t_date' ] ));
		update_option( 'pppm_doc_t_md', pppm_filter_strip( $_POST[ 'pppm_doc_t_md' ] ));
		update_option( 'pppm_save_doc_img_max_width', intval( $_POST[ 'pppm_save_doc_img_max_width' ] ));
		update_option( 'pppm_save_doc_template', intval( $_POST[ 'pppm_save_doc_template' ] ));
		update_option( 'pppm_save_doc_button_type', intval( $_POST[ 'pppm_save_doc_button_type' ] ));
		update_option( 'pppm_save_doc_button_url', pppm_filter_strip( $_POST[ 'pppm_save_doc_button_url' ] ));
		update_option( 'pppm_save_doc_button_text', pppm_filter_strip( $_POST[ 'pppm_save_doc_button_text' ] ));
		update_option( 'pppm_save_doc_icon_url', pppm_filter_strip( $_POST[ 'pppm_save_doc_icon_url' ] ));
		update_option( 'pppm_save_doc_css', pppm_filter_strip( $_POST[ 'pppm_save_doc_css' ] )); //v1.0.4
		
		
		update_option( 'pppm_save_pdf_img_show', intval( $_POST[ 'pppm_save_pdf_img_show' ] ));
		update_option( 'pppm_save_pdf_img_max_width', intval( $_POST[ 'pppm_save_pdf_img_max_width' ] ));
		update_option( 'pppm_save_pdf_rus', intval( $_POST[ 'pppm_save_pdf_rus' ] ));
		update_option( 'pppm_save_pdf_button_type', intval( $_POST[ 'pppm_save_pdf_button_type' ] ));
		update_option( 'pppm_save_pdf_button_url', pppm_filter_strip( $_POST[ 'pppm_save_pdf_button_url' ] ));
		update_option( 'pppm_save_pdf_button_text', pppm_filter_strip( $_POST[ 'pppm_save_pdf_button_text' ] ));
		update_option( 'pppm_save_pdf_icon_url', pppm_filter_strip( $_POST[ 'pppm_save_pdf_icon_url' ] ));
		
		update_option( 'pppm_save_xml_button_type', intval( $_POST[ 'pppm_save_xml_button_type' ] ));
		update_option( 'pppm_save_xml_button_url', pppm_filter_strip( $_POST[ 'pppm_save_xml_button_url' ] ));
		update_option( 'pppm_save_xml_button_text', pppm_filter_strip( $_POST[ 'pppm_save_xml_button_text' ] ));
		update_option( 'pppm_save_xml_icon_url', pppm_filter_strip( $_POST[ 'pppm_save_xml_icon_url' ] ));
	
	}
	#############################################################################################
	
		
?>
		
<br />
<table width="100%" border="0" cellspacing="1" class="pppm_option_table">
  <tr>
    <td class="pppm_table_td">
	<div class="pppm_top_desc">
		<?php _e('Here you can manage saving of posts and pages as PDF, HTML , Text , XML file and Word Document .') ?>
	</div>
	</td>
  </tr>
</table> 
<br />
<form id="pppm_form_saving" name="pppm_form_saving" method="post" action="<?php echo str_replace( '%7E', '~', $_SERVER['REQUEST_URI']); ?>">
					<input type="hidden" name="pppm_hidden" value="pppm_saving">
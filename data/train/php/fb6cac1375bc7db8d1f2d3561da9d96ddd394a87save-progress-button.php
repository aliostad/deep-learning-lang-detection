<?php
/**
 * Outputs the HTML for the save button.
 *
**/
add_action('init', 'ninja_forms_register_display_save_button');
function ninja_forms_register_display_save_button(){
	add_action('ninja_forms_display_after_fields', 'ninja_forms_display_save_button');
}

function ninja_forms_display_save_button($form_id){
	global $ninja_forms_processing;

	$form_row = ninja_forms_get_form_by_id($form_id);
	$form_data = $form_row['data'];

	if( isset( $form_data['save_progress'] ) ){
		$save_progress = $form_data['save_progress'];
	}else{
		$save_progress = 0;
	}

	if( isset( $form_data['multi_save'] ) ){
		$multi_save = $form_data['multi_save'];
	}else{
		$multi_save = 0;
	}

	if( isset( $_REQUEST['save_id'] ) ){
		$save_id = $_REQUEST['save_id'];
	}else if( is_object( $ninja_forms_processing ) ){
		$save_id = $ninja_forms_processing->get_form_setting( 'sub_id' );
	}else{
		$save_id = '';
	}

	if(is_user_logged_in() AND $save_progress == 1 AND !is_admin() AND ( !isset( $_REQUEST['ninja_forms_action'] ) OR $_REQUEST['ninja_forms_action'] == 'edit_save' OR $_REQUEST['ninja_forms_action'] == 'delete_save' ) ){
	?>
	<div id="ninja_forms_form_<?php echo $form_id;?>_save_progress">
		<input type="submit" name="_save_progress" value="<?php _e( 'Save Progress', 'ninja-forms-save-progress' );?>">
		<?php
		if( $multi_save == 1 AND $save_id != '' ){
			$cancel_url = remove_query_arg( array( 'save_id', 'ninja_forms_action' ) );
			?>
			<a href="<?php echo $cancel_url;?>"><input type="button" name="_cancel_save_progress" value="<?php _e( 'Cancel', 'ninja-forms-save-progress' );?>"></a>
			<?php
		}
		?>
	</div>
	<?php
	}
}
<?php
/**
 * AJAX Functions
 */

// Exit if accessed directly
if ( ! defined( 'ABSPATH' ) ) die();

function sd_check_customer_type(){
	if(!wp_verify_nonce($_POST['nonce'], 'sd_add_customer')) wp_die('Security Check');
	$customer_id = absint($_POST['customer_id']);
	$customer = array();

	$customer['type'] = sd_get_customer_type($customer_id);
	$customer['name'] = sd_get_customer_display_name($customer_id);
	$customer['phone'] = sd_get_customer_phone($customer_id);
	$customer['email'] = sd_get_customer_email($customer_id);
	
	echo json_encode($customer);
	die();
}

add_action( 'wp_ajax_sd_check_customer_type', 'sd_check_customer_type' );
<?php
function UKMprogram_ajax() {
	if(isset($_POST['c'])&&isset($_POST['v'])) {
		require_once('ajax/control/'.$_POST['c'].'.c.php');
		require_once('ajax/view/'.$_POST['v'].'.v.php');
		unset($_POST['c']);
		unset($_POST['v']);
		unset($_POST['action']);
		die(UKMprogram_ajax_view(UKMprogram_ajax_controller($_POST)));	
	}
	
	if(isset($_POST['save'])) {
		require_once('ajax/save/'.$_POST['save'].'.save.php');
		unset($_POST['c']);
		unset($_POST['v']);
		unset($_POST['action']);
		unset($_POST['save']);
		UKMprogram_save($_POST);
	}
}

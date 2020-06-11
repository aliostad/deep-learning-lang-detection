<?php
function ukmdeltakere_ajax_buttons($save, $bid) {
	return '<div class="UKMdeltakere_buttons">'
		.   '<a class="ajax_cancel" href="#">avbryt</a> '
		.   '<input type="button" value="Lagre" class="ajax_save" save="'.$save.'" bid="'.$bid.'" />'
		.  '</div>';
}

function UKMdeltakere_gui() {
	if(isset($_POST['c'])&&isset($_POST['v'])&&isset($_POST['i'])) {
		require_once('ajax/control/'.$_POST['c'].'.c.php');
		require_once('ajax/view/'.$_POST['v'].'.v.php');

		die(UKMdeltakere_ajax_view(UKMdeltakere_ajax_controller($_POST['i'])));	
	}
	
	if(isset($_POST['save'])) {
		require_once('ajax/save/'.$_POST['save'].'.save.php');
		UKMdeltakere_save();
	}
}

?>
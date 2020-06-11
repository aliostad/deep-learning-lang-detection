<?php
class SavesController extends Controller {
	function beforeAction() {
		$this->render = 0;
	}
	
	function afterAction() {
		
	}
	function add() {
		if (isset($_POST['save_type']) && isset($_POST['save_id'])) {
			if ($_POST['save_type']=='u')
				$this->save_user($_POST['save_id']);
			elseif ($_POST['save_type']=='r')
				$this->save_rental($_POST['save_id']);
		}
	}
	
	function remove() {
		if (isset($_POST['save_id'])) {
			$this->Save->id = $_POST['save_id'];
			$this->Save->delete();
		}
	}
	
	function save_user($user_id) {
		if (isset($_COOKIE['tmls_uniq_sess'])) {
			$xUserData = performAction('users','check_user',array($_COOKIE['tmls_uniq_sess']));
			$this->Save->user_id = $xUserData[0]['User']['id'];
			$this->Save->saved_user_id = $user_id;
			$save_id = $this->Save->save(true);
			echo $save_id;
			if($save_id)
				return 1;
			else
				return -1;
		} else
			return -1;
	}
	
	function save_rental($rental_id) {
		if (isset($_COOKIE['tmls_uniq_sess'])) {
			$xUserData = performAction('users','check_user',array($_COOKIE['tmls_uniq_sess']));
			$this->Save->user_id = $xUserData[0]['User']['id'];
			$this->Save->saved_rental_id = $rental_id;
			if($this->Save->save())
				return 1;
			else
				return -1;
		} else
			return -1;
	}
}
?>
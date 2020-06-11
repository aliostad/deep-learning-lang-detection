<?php
	// widgets/chat/send.php
	header("content-type: text/html; charset=UTF-8");
	// inint
	include ('../../bin/inint.php');
	// referer
	if (gcms::isReferer()) {
		// login
		$login = gcms::getVars($_SESSION, 'login', array('id' => 0, 'status' => -1, 'email' => '', 'password' => ''));
		// ค่าที่ส่งมา
		$save = array();
		$save['text'] = stripslashes($db->sql_trim_str($_POST, 'val', ''));
		$save['time'] = gcms::getVars($_POST, 'time', 0);
		$save['sender'] = $login['displayname'] == '' ? trim("$login[fname] $login[lname]") : $login['displayname'];
		if ($save['sender'] == '') {
			$ds = explode('@', $login['email']);
			$save['sender'] = $ds[0];
		}
		// save message
		$db->add(DB_CHAT, $save);
	}

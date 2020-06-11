<?php
	// modules/member/fb_login.php
	header("content-type: text/html; charset=UTF-8");
	// inint
	include '../../bin/inint.php';
	// ตรวจสอบ referer
	if (gcms::isReferer()) {
		// ค่าที่ส่งมา
		foreach (explode('&',$_POST['data']) AS $item) {
			list($k, $v) = explode('=', $item);
			$$k = $v;
		}
		// สุ่มรหัสผ่านใหม่
		$login_password = gcms::rndname(6);
		// ตรวจสอบสมาชิกกับ db
		$sql = "SELECT `id`,`email`,`icon`,`fb` FROM `".DB_USER."` WHERE `email`='".addslashes($email)."' LIMIT 1";
		$save = $db->customQuery($sql);
		if (sizeof($save) == 0) {
			// ยังไม่เคยลงทะเบียน, ลงทะเบียนใหม่
			$save = array();
			if (preg_match('/^([0-9]+)[\/\-]([0-9]+)[\/\-]([0-9]+)$/', $birthday, $match)) {
				$save['birthday'] = "$match[3]-$match[1]-$match[2]";
			}
			$save['id'] = 1 + $db->lastId(DB_USER);
			$save['email'] = $email;
			$save['icon'] = "$save[id].jpg";
			$save['sex'] = $gender == 'male' ? 'm' : 'f';
			$save['website'] = str_replace(array('http://', 'https://', 'www.'), '', $link);
			$save['password'] = md5($login_password.$save['email']);
			$save['fname'] = $first_name;
			$save['lname'] = $last_name;
			$save['displayname'] = $name;
			$save['fb'] = 1;
			$save['subscrib'] = 1;
			$save['visited'] = 1;
			$save['lastvisited'] = $mmktime;
			$save['create_date'] = $mmktime;
			$save['ip'] = gcms::getip();
			$lastid = $db->add(DB_USER, $save);
			// post to facebook สำหรับครั้งแรก
			if (!empty($config['facebook_message'])) {
				$ret['message'] = rawurlencode(stripslashes(str_replace(array('\r', '\n'), array("\r", "\n"), $config['facebook_message'])));
				if (is_file(DATA_PATH.'image/facebook_photo.jpg')) {
					$ret['picture'] = DATA_URL.'image/facebook_photo.jpg';
				}
				$ret['id'] = $id;
			}
		} elseif ($save[0]['fb'] == 1) {
			$save = $save[0];
			// facebook เคยเยี่ยมชมแล้ว อัปเดทการเยี่มชม
			$save['visited']++;
			$save['lastvisited'] = $mmktime;
			$save['ip'] = gcms::getip();
			$save['password'] = md5($login_password.$save['email']);
			$db->edit(DB_USER, $save['id'], $save);
		} else {
			// ไม่สามารถ login ได้ เนื่องจากมี email อยู่ก่อนแล้ว
			$save = false;
			$ret['error'] = 'EMAIL_EXISTS';
			$ret['isMember'] = 0;
		}
		if (is_array($save)) {
			// อัปเดท icon สมาชิก
			$data = @file_get_contents("https://graph.facebook.com/$id/picture");
			if ($data) {
				$f = @fopen(USERICON_FULLPATH.$save['icon'], 'wb');
				if ($f) {
					fwrite($f, $data);
					fclose($f);
				}
			}
			// login
			$_SESSION['login'] = $save;
			$_SESSION['login']['password'] = $login_password;
			// reload
			$ret['isMember'] = 1;
			if (preg_match('/module=(do)?login/', $_POST['u']) || preg_match('/(do)?login\.html/', $_POST['u'])) {
				$ret['location'] = 'back';
			} else {
				$ret['location'] = 'reload';
			}
		}
		// คืนค่าเป็น JSON
		echo gcms::array2json($ret);
	}

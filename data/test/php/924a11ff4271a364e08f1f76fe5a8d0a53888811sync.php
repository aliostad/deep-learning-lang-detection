<?php
include 'okSession.php';

$okSession = &getOkSession();
if($okSession) {
	try {

		$userId = $okSession['userId'];
		if(isset($okSession['content'])) {
			$content = $okSession['content'];
			if(isset($content['action'])) {
				if($content['action'] == 'sync') {
					$lastSyncIndSave = intval($content['last_sync_ind_save']);
					$retSaves = array();
					if(isset($content['saves'])) {
						$newSaves = $content['saves'];
						$firstInd = 0;
						foreach($newSaves as $ind => $data) {
							$firstInd = $ind;
							break;
						}
						$collision = false;
						$str = "SELECT save_ind, data FROM save WHERE user_id=".$userId." AND save_ind>".$lastSyncIndSave." ORDER BY save_ind LIMIT 1";
						if($q = $mysqli->query($str)) {
							while($save = $q->fetch_assoc()) {
								if(isset($save['save_ind']) && !$collision) {
									if($save['data'] != $newSaves[$save['save_ind']]) {
										$collision = true;
										$retSaves[$save['save_ind']] = $save['data'];
									}
								} else {
									$retSaves[$save['save_ind']] = $save['data'];
								}
							}
						}
					} else {
						$str = "SELECT save_ind, data FROM save WHERE user_id=".$userId." AND save_ind>".$lastSyncIndSave." ORDER BY save_ind";
						if($q = $mysqli->query($str)) {
							while($save = $q->fetch_assoc()) {
								$say[] = $save['save_ind'];
								$say[] = $str;
								$retSaves[$save['save_ind']] = $save['data'];
							}
						}
					}
					if(empty($retSaves)) {
						if(isset($content['saves'])) {
							$newSaves = $content['saves'];
							foreach($newSaves as $newSaveInd => $saveObj) {
								$newSaveInd = intval($newSaveInd);
								$saveJson = $saveObj;
								$saveJsonTyp = intval($saveJson['typ']);
								$saveStr = $mysqli->real_escape_string(json_encode($saveObj));
								if(!empty($saveStr)) {
									if(!isset($saveJson['typ'])) {
										$err[] = 'Missing typ of save by ind ' . $newSaveInd;
										break;
									} else {
										$str = "INSERT INTO save (user_id, save_ind, typ, data) VALUES (".$userId.", ".$newSaveInd.", ".$saveJsonTyp.", '".$saveStr."')";
										$say[] = $str;
										if($q = $mysqli->query($str)) {
											$ret['ok_save'] = 1;
											$ret['last_sync_ind_save'] = $newSaveInd;
										}
									}
								}
							}
						}
					} else {
						$ret['saves'] = &$retSaves;
					}
				}
			}
		}

		incrementActionInd(&$okSession);

	} catch(Exception $e) {
		$err[] = $e->getMessage();
	}
}
echo json_encode($ret);

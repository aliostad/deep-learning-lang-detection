<?php
include 'fastFuncs.php';

$postData = json_decode(file_get_contents("php://input"), true);
$say = array();
$err = array();
$ret = array('say' => &$say, 'err' => &$err);
try {
	if(empty($postData)) {
		$err[] = 'Incorrect post data.';
	} else if(!isset($postData['session_id'])) {
		$err[] = 'No session_id parameter.';
	} else {
		$sessionId = $mysqli->real_escape_string($postData['session_id']);
		$check = $postData['check'];
		if($q = $mysqli->query("SELECT user_id, action_ind, seed FROM session where id=".$sessionId)) {
			$session = $q->fetch_assoc();
			$userId = $session['user_id'];
			$actionInd = $session['action_ind'];
			$seed = $session['seed'];
			$ret['parsed'] = 1;
			$veryMuchChangesLogs = 0;
			$say[] = $sessionId . ', ' . $seed . ', ' . $actionInd;
			if($check == hash('sha256', $sessionId . $seed . $actionInd)) { // значит притензий к сессии нет.
				$ret['check'] = 'ok';

				if(isset($postData['content'])) {
					$content = $postData['content'];
					if(isset($content['action'])) {
						if($content['action'] == 'sync') {
							$lastSyncIndSave = $content['last_sync_ind_save'];
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
								$str = "SELECT save_ind, data FROM save WHERE user_id=".$userId." AND save_ind>".$lastSyncIndSave." ORDER BY save_ind LIMIT 1";
								if($q = $mysqli->query($str)) {
									while($save = $q->fetch_assoc()) {
										$retSaves[$save['save_ind']] = $save['data'];
									}
								}
							}
							if(empty($retSaves)) {
								if(isset($content['saves'])) {
									$newSaves = $content['saves'];
									foreach($newSaves as $newSaveInd => $newSaveData) {
										$saveJson = json_decode($newSaveData, true);
										if(!empty($saveJson)) {
											if(!isset($saveJson['typ'])) {
												$err[] = 'Missing typ of save by ind ' . $newSaveInd;
												break;
											} else {
												$str = "INSERT INTO save (user_id, save_ind, typ, data) VALUES (".$userId.", ".$newSaveInd.", ".$saveJson['typ'].", '".$content['data']."', 1)";
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
				
				// Если до этого момента не вылетело - считаем действие состоявшимся.
				$str = "UPDATE session SET action_ind=" . ($actionInd + 1) . " WHERE id=".$sessionId;
				if($q = $mysqli->query($str)) {
					$ret['status'] = 'ok';
				} else {
					//warning('No incremented action_ind ' . $str);
					if(!$q = $mysqli->query($str)) { // дадим еще одну попытку.
						warning('No incremented action_ind ' . $str);
					} else {
						$ret['status'] = 'ok';
					}
				}
			} else {
				$ret['check'] = 'no';
				$err[] = 'Wrong check.';
				//warning('No identical check.');
			}
		} else {
			$err[] = 'Current session not found.';
			//warning('Current session not found.');
			return;
		}
	}
} catch(Exception $e) {
	$err[] = $e->getMessage();
}
echo json_encode($ret);

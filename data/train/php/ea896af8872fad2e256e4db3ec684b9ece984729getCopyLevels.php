<?php
include $_SERVER['DOCUMENT_ROOT'].'/init.inc.php';
$userId = $_REQUEST['user_id'] ? $_REQUEST['user_id'] : 0;
$copyId     = isset($_REQUEST['copy_id']) ? $_REQUEST['copy_id'] : 0;

$levels = Copy_Config::getCopyLevels();
$copy = Copy::getCopyInfoByCopyId($copyId); 

foreach ($levels as $k => $v) {
	$fightRes = Copy_FightResult::getResult($userId, $v['level_id'], 0, date("Y-m-d",time()));
	$levels[$k]['win_monster_num'] = $fightRes['win_monster_num'] ? $fightRes['win_monster_num'] : 0;
	$levels[$k]['residue_degree'] = $copy['monster_num'] - $fightRes['win_monster_num'];
}
$data = $levels;


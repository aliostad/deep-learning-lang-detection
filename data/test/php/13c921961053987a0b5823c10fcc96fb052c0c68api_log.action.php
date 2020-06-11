<?php
class api_log{
	public function index()
	{		
		$api = strim($GLOBALS['request']['api']);
		$act = strim($GLOBALS['request']['api_act']);
		//echo $api; exit;
		$root = array();
		$root['response_code'] = 1;		
	
			$root['user_login_status'] = 0;		

			$id = intval($GLOBALS['request']['id']);//id,有ID值则更新，无ID值，则插入
		
			$api_log = array();
			$api_log['api'] = $api;
			$api_log['act'] = $act;
			$GLOBALS['db']->autoExecute(DB_PREFIX."api_log", $api_log, 'INSERT');

		output($root);
	}
}
?>
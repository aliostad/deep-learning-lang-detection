<?php
include_once './config.inc.php';
require_once GLOBAL_LIB_ROOT. '/common.php';
require_once LIB_ROOT_V2 . '/LogManager.class.php';

try{
	LogManager::enter();
}catch (Exception $e){
	exit_with_error($e->getMessage(),10013);
}

try{
	require_once LIB_ROOT_V2. '/SaveLogManager.class.php';
	SaveLogManager::openCheck();
	if(isset($_REQUEST['logs']) || isset($_REQUEST['log'])){
		if($_REQUEST['uid'])
			SaveLogManager::saveLog('base_package');
		else 
			SaveLogManager::saveLog('store');
	}
	else if(isset($_REQUEST['json'])){
		SaveLogManager::saveLog('all');
	}
	else{
		SaveLogManager::saveLog('base');
	}
}catch (Exception $e){
	exit_with_error('save sns log error',10013);
}


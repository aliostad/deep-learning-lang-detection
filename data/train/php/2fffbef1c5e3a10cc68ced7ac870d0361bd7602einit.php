<?php
/******************************************************
**
** WP Importer
** init.php
**
** @description: プラグインインストール　初期化
** @author: G.Maniwa
** @date: 2012-12-24
**
*****************************************************/

	//XML保管用
	$filesPath = WWW_ROOT.'files';
	$savePath = $filesPath.DS.'wpxml';
	if(is_writable($filesPath) && !is_dir($savePath)){
		mkdir($savePath);
		chmod($savePath,0777);
	}
	if(!is_writable($savePath)){
		chmod($savePath,0777);
	}

?>
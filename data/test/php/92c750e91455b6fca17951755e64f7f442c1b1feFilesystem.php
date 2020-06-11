<?
if (!defined('BASEPATH')) exit('No direct script access allowed');
class Cache_Filesystem extends Base_Filesystem {

	var $save_path="/tmp";
	
	function __construct($savePath="/tmp") {
		$this->save_path=$savePath;
		
	}

	function setSavePath($savePath) {
		
		$this->save_path=$savePath;

	}

	function isCached($key) {
		return $this->file_exists("{$this->save_path}/$key");
	}
	
	function lifeTime($key) {
		return $this->fileAge("{$this->save_path}/$key");
	}	
	
	function saveCache($key,$content) {
//		dump_var($content);
		$this->writefile("{$this->save_path}/$key",$content);
	}
	
	function readCache($key,$content) {
		return $this->readfile("{$this->save_path}/$key");
	}
	
}
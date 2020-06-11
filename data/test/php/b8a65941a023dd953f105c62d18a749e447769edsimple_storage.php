<?
class simple_storage_lib{
	private $repositories = array();
	
	function __construct(){
		$this->path = realpath(".");
	}
	
	function __get($repository){
		if(!isset($this->repositories[$repository])){
			$repository_filename = $this->path.'/'.APP.'/cache/'.$repository.'.cache';
			if( file_exists( $repository_filename ) ){
				$this->repositories[$repository] = unserialize(file_get_contents($repository_filename));
			}else{
				$this->repositories[$repository] = new stdClass();
			}
		}
		return ($this->repositories[$repository]);
	}
	function __destruct(){
		foreach( $this->repositories as $repository_name=>$repository ){
			$repository_filename = $this->path.'/'.APP.'/cache/'.$repository_name.'.cache';
			file_put_contents($repository_filename, serialize($repository),LOCK_EX);
		}
	}
}


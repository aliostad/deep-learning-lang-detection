<?php

class RepositoryFactory extends Singleton
{
    /** @var instance */
    protected static $instance;
    protected $db;
    protected $repository;

    public function __construct(){
			$this->db = DbManager::getInstance()->getDb();
    }

    public function findRepository($repository)
    {

       $this->repository  = $repository;
       //var_dump('repository/'.$this->repository.'.php');
       if( file_exists($chemin =APPLICATION_PATH.'models/managers/'.$this->repository.'.php')){
           require $chemin;
           return new $this->repository;
       }else{
           throw new RuntimeException('fichier :'.$repository.' non trouvé');
       }
    }

    public function create() {}
    public function read() {}
    public function update() {}
    public function delete() {}
}


<?php

class RepositoryRouter {
	protected $repositories = array();
	protected $connection;
	
	public function __construct($connection) {
		$this->connection = $connection;
	}
	
	public function __get($repository) {
		$repository = strtolower($repository);
		
		if(isset($this->repositories[$repository])) {
			return $this->repositories[$repository];
		} else {
			$class = new ReflectionClass(ucfirst($repository) . 'Repository');
			$repositoryObject = $class->newInstanceArgs(array($this->connection));
			
			$this->repositories[$repository] = $repositoryObject;
			
			return $repositoryObject;
		}
	}
}
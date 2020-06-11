<?php

/**
 * Base class for database wrappers we call repositories.
 * 
 */
Kurogo::includePackage('db');
class Repository {

	private $conn;
	
	protected function connection() {
		if (!$this->conn) {
			$this->conn = SiteDB::connection();
		}
		 
		return $this->conn;
	}
	
	protected function init($options) {
		// do nothing
	}
	
	public static function factory($repositoryClass, $options) {
		Kurogo::log(LOG_DEBUG, "Initializing Repository $repositoryClass", "repository");
		if (!class_exists($repositoryClass)) {
			throw new KurogoConfigurationException("Repository class $retrieverClass not defined");
		}
		
		$repository = new $repositoryClass;

		if (!$repository instanceOf Repository) {
			throw new KurogoConfigurationException(get_class($repository) . " is not a subclass of Repository");
		}
		
		$repository->init($options);
		return $repository;
		
	}

}
<?php 
namespace GL\Core\Facades;

use GL\Core\Facades\Facade as BaseFacade;

class ParametersFacade extends BaseFacade {

	private static $instance;

	protected static function getInstance()
	{
		 if ( self::$instance === NULL) {
     
		$c = new self();
	    self::$instance = new \GL\Core\Config\Parameters;
	    }
	    return self::$instance;
	}
   	
   	/**
   	 * 
   	 * Return class instance or service name in string 
   	 */
    protected static function getFacadeAccessor() { return self::getInstance() ; }

}
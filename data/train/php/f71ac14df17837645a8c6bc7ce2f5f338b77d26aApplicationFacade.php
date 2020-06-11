<?php
require_once PUREMVC.'patterns/facade/Facade.php';
require_once COMMON.'controller/command/CommonInitialiseCommand.php';
require_once BASEDIR.'controller/commands/application/StateCommand.php';

foreach( glob(BASEDIR.'controller/commands/view/*.php') as $filename ) require $filename;

class ApplicationFacade extends Facade
{
	// Global commands
	const INITIALISE 	= "application/initialise";
	const STATE		 	= "application/state";
    
    //API commands
	const JSON_TEST		= "commands/json/test";
	const HTML_TEST		= "commands/html/test";
    
    
	static public function getInstance()
	{
		if (parent::$instance == null) parent::$instance = new ApplicationFacade();
		return parent::$instance;
	}
	
	protected function initializeController()
	{
		parent::initializeController();
		
		// Global commands
		$this->registerCommand( ApplicationFacade::INITIALISE, 'CommonInitialiseCommand' );
		$this->registerCommand( ApplicationFacade::STATE,      'StateCommand' );		
		
		// API views
		$this->registerCommand( ApplicationFacade::JSON_TEST, 'APITest' );
		$this->registerCommand( ApplicationFacade::HTML_TEST, 'HTMLTest' );
        
	}	
	
	public function initialise()
	{
		$this->sendNotification( ApplicationFacade::INITIALISE );
		$this->removeCommand( ApplicationFacade::INITIALISE );
	}
}

?>
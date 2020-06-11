<?php
class OverviewCommand extends ExtendedSimpleCommand
{
	public function execute( INotification $notification )
	{	
		parent::execute( $notification);
		
		$this->module = "home";
		
		$content = "Logged in ".easylink("(logout)", $this->logout_link );
		
	
		$tokens = array( 
			'{CONTENT}' => $content
		);
		
		$this->facade->sendNotification( ApplicationFacade::TEMPLATE, $this->container );
		$this->facade->sendNotification( ApplicationFacade::TOKENIZE, $tokens );
		$this->facade->sendNotification( ApplicationFacade::TOKENIZE, $this->getUniversalTokens() );
		$this->facade->sendNotification( ApplicationFacade::RENDER );
		
	}
}

?>

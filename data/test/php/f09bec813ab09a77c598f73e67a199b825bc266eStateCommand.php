<?php

require_once PUREMVC.'patterns/command/SimpleCommand.php';  
require_once PUREMVC.'interfaces/INotification.php';
require_once BASEDIR.'ApplicationFacade.php';

class StateCommand extends SimpleCommand
{
	public function execute( INotification $notification )
	{		
		$command = ( isset( $_REQUEST['command'] ) ) ? $_REQUEST['command'] : 'default';
		
		switch( $command )
		{
			case 'default': $this->facade->sendNotification( ApplicationFacade::VIEW_LOGIN ); break;
			case 'login': $this->facade->sendNotification( ApplicationFacade::VIEW_LOGIN ); break;
			case 'logout':  $this->facade->sendNotification( ApplicationFacade::VIEW_LOGOUT  ); break;			
		}
	}
}

?>

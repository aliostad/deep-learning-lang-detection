<?php
/**
*
* @author Saad Shams :: sshams@live.com
*
* Copy, reuse is prohibited.
* 
*/

require_once ('library/PureMVC_PHP_1_0_2.php');
require_once ('ApplicationFacade.php');
require_once ('model/URIProxy.php');
require_once ('library/Session.php');

class StartupCommand extends SimpleCommand implements ICommand {
	
	public function execute(INotification $notification) {
	
		$this->facade->registerProxy(new URIProxy());
		$params = $this->facade->retrieveProxy(URIProxy::NAME)->getData();
		
		switch($params[0]) {
			case ApplicationFacade::LOGIN:
				$this->facade->sendNotification(ApplicationFacade::LOGIN);
				break;
			case ApplicationFacade::USER:
				$this->facade->sendNotification(ApplicationFacade::USER);
				break;
			default:
				$this->facade->sendNotification(ApplicationFacade::LOGIN);
				break; 
		}

	
	}
}
?>
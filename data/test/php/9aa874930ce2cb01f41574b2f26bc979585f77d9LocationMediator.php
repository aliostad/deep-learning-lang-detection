<?php

require_once ('_libs/PureMVC_PHP_1_0_2.php');
require_once ('ApplicationFacade.php');
require_once ('view/components/Location.php');

class LocationMediator extends Mediator implements IMediator {
	
	const NAME = "LocationMediator";
	
	public function __construct(Location $location) {
		parent::__construct(self::NAME, $location);
	}
	
	public function listNotificationInterests() {
		return array(
			ApplicationFacade::LOCATION,
			ApplicationFacade::SORRY,
			ApplicationFacade::ANSWERED,
			ApplicationFacade::ACCESS_DENIED
		);
	}
	
	public function handleNotification(INotification $notification) {
		switch($notification->getName()) {
			case ApplicationFacade::LOCATION:
				$this->viewComponent->getLocation($notification->getBody());
				break;
			case ApplicationFacade::SORRY:
				$this->viewComponent->sorry();
				break;
			case ApplicationFacade::ANSWERED:
				$this->viewComponent->answered();
				break;
			case ApplicationFacade::ACCESS_DENIED:
				$this->viewComponent->access_denied();
				break;
		}
	}
}

?>
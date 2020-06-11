<?php
class ServiceManager {
	private $objServiceStore;
	public function __construct($objServiceStore) {
		$this->objServiceStore = $objServiceStore;
	}
	public function addService($objService) {
		return $this->objServiceStore->addService($objService);
	}
	public function editService($objService) {
		return $this->objServiceStore->editService($objService);
	}
	public function getService($serviceId) {
		return $this->objServiceStore->getService($serviceId);
	}
	public function deleteService($serviceId) {
		return $this->objServiceStore->deleteService($serviceId);
	}
	public function listService($serverId) {
		$objServiceTypeManager = NCConfigFactory::getInstance()->getServiceTypeManager();
		$serviceTypes = $objServiceTypeManager->listServiceType();
		$serviceTypesArr = array();
        foreach($serviceTypes as $serviceType) {
            $serviceTypesArr[$serviceType['serviceTypeId']] = $serviceType['serviceTypeName'];
        }

		$services = $this->objServiceStore->listService($serverId);		
        foreach($services as $key=>$service) {
            $services[$key]['serviceTypeName'] = $serviceTypesArr[$service['serviceTypeId']];
			$services[$key]['serviceLabel'] = $services[$key]['serviceTypeName'].' ('.$service['servicePort'].') - '.$service['serviceRefName'];
        }
		return $services;
	}
	public function validateService($serverId,$serviceTypeId,$servicePort) {
		$status = $this->objServiceStore->validateService($serverId,$serviceTypeId,$servicePort);
		if($status)	
			return false;
		return true;
	}
	public function validateServiceRefName($serviceRefName) {
		$status = $this->objServiceStore->validateServiceRefName($serviceRefName);
		if($status)
			return false;
		return true;
	}
}
?>

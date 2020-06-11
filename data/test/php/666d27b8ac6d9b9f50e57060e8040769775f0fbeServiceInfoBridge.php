<?php
namespace Devture\Bundle\NagiosBundle\ApiModelBridge;

use Devture\Bundle\NagiosBundle\Model\ServiceInfo;
use Devture\Bundle\NagiosBundle\Status\ServiceStatus;

class ServiceInfoBridge {

	private $serviceBridge;
	private $serviceStatusBridge;

	public function __construct(ServiceBridge $serviceBridge, ServiceStatusBridge $serviceStatusBridge) {
		$this->serviceBridge = $serviceBridge;
		$this->serviceStatusBridge = $serviceStatusBridge;
	}

	public function export(ServiceInfo $entity) {
		$status = $entity->getStatus();
		$service = $entity->getService();

		return array(
			'id' => (string) $service->getId(),
			'service' => $this->serviceBridge->export($service),
			'status' => ($status instanceof ServiceStatus ? $this->serviceStatusBridge->export($status) : null),
		);
	}

}
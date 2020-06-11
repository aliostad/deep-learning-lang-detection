<?php

namespace Syzygy\ApiStack\Protocol\Base;

use Syzygy\ApiStack\Service\Base\ServiceInterface;

abstract class ServiceAwareStringProtocol implements StringProtocolInterface {

	/** @var \Syzygy\ApiStack\Service\Base\ServiceInterface */
	protected $service;

	/**
	 * @param ServiceInterface $service
	 */
	public function __construct(ServiceInterface $service=null) {
		if(!is_null($service)) {
			$this->setService($service);
		}
	}

	public function setService(ServiceInterface $service) {
		$this->service = $service;
	}

}

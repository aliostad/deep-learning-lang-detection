<?php namespace Altenia\Ecofy\Service;

/**
 * Base class for all services
 */
class BaseService {

	/** Service id **/
	private $id;

	/**
	 * The service that contains this service.
	 * E.g. In blog-comment relation, the Blog service will be container, and comment will be contained
	 */
	private $containerService = null;

	/**
	 * The services that are contained in this service.
	 * E.g. If this service is blog then, comment and attachment services will be contained services.
	 */
	private $containedServices = array();

	/** Reference to the access control service **/
	private $acessControlService = null;

	public function __construct($id)
    {
        $this->id = $id;
    }

    /**
     * Returns the id
     */
	public function getId()
	{
		return $this->id;
	}

	/**
	 * 
	 * @param {string | Object} $sevice
	 */
	public function setContainerService($service, $registerAsContained = true)
	{
		if (is_object($service)) {
			$this->containerService = $service;
		} else if (is_string($service)) {
			// It's a service name, resolve and assign
			$this->containerService = ServiceRegistry::instance()->getServiceObject($service);
		}
		if ($registerAsContained === true) {
			// Also register itself as contained service in the container
			$this->containerService->addContainedService($this);
		}
	}

	public function getContainerService()
	{
		return $this->containerService;
	}

	/**
	 * Returns the top-most (root) container service
	 */
	public function getRootContainerService()
	{
		$service = $this;
		while($service !== null) {
			if ($service->containerService === null) {
				return $service;
			}
			$service = $service->containerService;
		}
	}

	/**
	 * Returns the the path of the servers from the root service
	 * @param array
	 */
	public function getServicePath()
	{
		$retval = array();
		$service = $this;
		while($service !== null) {
			$retval[] = $service->getId();
			if ($service->containerService === null) {
				return array_reverse($retval);
			}
			$service = $service->containerService;
		}
	}

	/**
	 * Adds a contained (e.g. child) service
	 * @param {string | Object} $sevice
	 */
	public function addContainedService($service)
	{
		$service_ref = null;
		if (is_object($service)) {
			$service_ref = $service;
		} else if (is_string($service)) {
			// It's a service name, resolve and assign
			$service_ref = \App::make($service);
		}
		if (in_array($service, $this->containedServices)) {
			$this->containedServices[] = $service_ref;
		}
	}

	/**
	 * Returns the access control service
	 */
	public function getAccessControlService()
	{
		if ($this->acessControlService == null) {
			// @todo - externalize the access_control service name
			$this->acessControlService = ServiceRegistry::instance()->findById('access_control');
		}
		return $this->acessControlService;
		
	}

}
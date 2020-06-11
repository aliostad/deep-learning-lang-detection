<?php
namespace ZendPattern\Zsf\Api;

use Zend\EventManager\Event;
use ZendPattern\Zsf\Api\ApiRequest;
use ZendPattern\Zsf\Api\Response\ResponseAbstract;
use ZendPattern\Zsf\Api\Service\ApiServiceAbstract;

class ApiCallEvent extends Event
{
	/**
	 * ApiCall feature
	 * 
	 * @var ApiCall
	 */
	protected $apiCall;
	
	/**
	 * Api Service
	 * 
	 * @var ApiServiceAbstract
	 */
	protected $apiService;
	
	/**
	 * API request
	 * 
	 * @var ApiRequest
	 */
	protected $request;
	
	/**
	 * Api response
	 * 
	 * @var ResponseAbstract
	 */
	protected $response;
	
	/**
	 * Boundary string used in multipart form-data encoded request
	 * 
	 * @var string
	 */
	protected $multiPartBoundary;
	
	/**
	 * @return the $request
	 */
	public function getRequest() {
		return $this->request;
	}

	/**
	 * @param \ZendPattern\Zsf\Api\ApiRequest $request
	 */
	public function setRequest($request) {
		$this->request = $request;
	}
	
	/**
	 * @return the $response
	 */
	public function getResponse() {
		return $this->response;
	}

	/**
	 * @param \ZendPattern\Zsf\Api\Response\ResponseAbstract $response
	 */
	public function setResponse($response) {
		$this->response = $response;
	}
	
	/**
	 * @return the $multiPartBoundary
	 */
	public function getMultiPartBoundary() {
		return $this->multiPartBoundary;
	}

	/**
	 * @param string $multiPartBoundary
	 */
	public function setMultiPartBoundary($multiPartBoundary) {
		$this->multiPartBoundary = $multiPartBoundary;
	}
	/**
	 * @return the $apiCall
	 */
	public function getApiCall() {
		return $this->apiCall;
	}

	/**
	 * @param \ZendPattern\Zsf\Api\Service\ServiceAbstract $apiCall
	 */
	public function setApiCall($apiCall) {
		$this->apiCall = $apiCall;
	}
	
	/**
	 * @return the $apiService
	 */
	public function getApiService() {
		return $this->apiService;
	}

	/**
	 * @param \ZendPattern\Zsf\Api\Service\ApiServiceAbstract $apiService
	 */
	public function setApiService($apiService) {
		$this->apiService = $apiService;
	}
}
<?php
namespace Epigra\SteamWebApi\Config;

/**
 * ApiConfiguration is key for API operations. 
 * It provides an simple interface to store API Url, Key and its response format.
 * This class should be initialized before Steam Web API operations.
 * 
 * @link [https://wiki.teamfortress.com/wiki/WebAPI] [Wiki For Web API]
 * @author Gokhan Akkurt
 *
 */
class ApiConfiguration{

	/**
	 *  API Url instance variable
	 */
	private $apiUrl;
	/**
	 *  API Key instance variable
	 */
	private $apiKey;
 	/**
	 *  Response format instance variable
	 */
 	private $responseFormat;

	 /**
	 *  Constructor for ApiConfiguration class.
	 * @param $apiUrl [Base url for API]
	 * @param $apiKey [An access key for API]
	 * @param $responseFormat [Response format type. This can be either json or xml]
	 */
	 public function __construct($url, $key, $format)
	 {		
	 	$this->apiUrl = $url;
	 	$this->apiKey = $key;
	 	$this->responseFormat = $format;
	 }

	 /**
	 *  Returns API Url
	 * @return $apiUrl [API Url for Steam Web]
	 */
	 public function getApiUrl()
	 {
	 	return $this->apiUrl;
	 }
	 
	 /**
	 *  Sets API Url to given parameter.
	 * @param $apiUrl [Base url for API]
	 */
	 public function setApiUrl($url)
	 {
	 	$this->apiUrl = $url;
	 }

	 /**
	 *  Returns stored API Key.
	 * @return $apiKey [Access key for API]
	 */
	 public function getApiKey()
	 {
	 	return $this->apiKey;
	 }

	 /**
	 *  Sets API Key to given parameter.
	 * @param $apiKey 
	 */
	 public function setApiKey($key)
	 {
	 	$this->apiKey = $key;
	 }

	/**
	 *  Returns response format for the API. 
	 * @return $responseFormat 
	 */
	 public function getResponseFormat()
	 {
	 	return $this->responseFormat;
	 }
	
	/**
	 *  Sets response format type.
	 * @param $responseFormat [Response format type. This can be either json or xml]
	 */
	 public function setResponseFormat($format)
	 {
	 	$this->responseFormat = $format;
	 }
}


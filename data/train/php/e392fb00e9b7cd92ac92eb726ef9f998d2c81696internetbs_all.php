<?php
/**
 * Internetbs API request funnel
 * @package internetbs.commands
 */
class InternetbsAll {
	
	/**
	 * @var InternetbsApi
	 */
	private $api;
	
	/**
	 * Sets the API to use for communication
	 *
	 * @param InternetbsApi $api The API to use for communication
	 */
	public function __construct(InternetbsApi $api) {
		$this->api = $api;
	}
	
	/**
	 * Returns the response from the Enom API
	 *
	 * @param array $vars An array of input params
	 * @return InternetbsResponse
	 */
	public function __call($command, array $vars) {
		return $this->api->submit($command, $vars[0]);
	}
}
?>
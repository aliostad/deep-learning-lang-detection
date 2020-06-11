<?php
/**
 * Opensrs API request funnel
 * @package opensrs.commands
 */
class OpensrsAll {
	
	/**
	 * @var OpensrsApi
	 */
	private $api;
	
	/**
	 * Sets the API to use for communication
	 *
	 * @param OpensrsApi $api The API to use for communication
	 */
	public function __construct(OpensrsApi $api) {
		$this->api = $api;
	}
	
	/**
	 * Returns the response from the Enom API
	 *
	 * @param array $vars An array of input params
	 * @return OpensrsResponse
	 */
	public function __call($command, array $vars) {
		return $this->api->submit($command, $vars[0]);
	}
}
?>
<?php

namespace Apple_Actions;

require_once plugin_dir_path( __FILE__ ) . 'class-action.php';
require_once plugin_dir_path( __FILE__ ) . 'class-action-exception.php';
require_once plugin_dir_path( __FILE__ ) . '../../includes/apple-push-api/autoload.php';

use Apple_Actions\Action as Action;
use Apple_Push_API\API as API;
use Apple_Push_API\Credentials as Credentials;

/**
 * A base class that API-related actions can extend.
 */
abstract class API_Action extends Action {

	/**
	 * The API endpoint for all Apple News requests.
	 */
	const API_ENDPOINT = 'https://u48r14.digitalhub.com';

	/**
	 * Instance of the API class.
	 *
	 * @var API
	 * @access private
	 */
	private $api;

	/**
	 * Set the instance of the API class.
	 *
	 * @param API $api
	 * @access public
	 */
	public function set_api( $api ) {
		$this->api = $api;
	}

	/**
	 * Get the instance of the API class.
	 *
	 * @return API
	 * @access protected
	 */
	protected function get_api() {
		if ( is_null( $this->api ) ) {
			$this->api = new API( self::API_ENDPOINT, $this->fetch_credentials() );
		}

		return $this->api;
	}

	/**
	 * Fetch the current API credentials.
	 *
	 * @return Credentials
	 * @access private
	 */
	private function fetch_credentials() {
		$key    = $this->get_setting( 'api_key' );
		$secret = $this->get_setting( 'api_secret' );
		return new Credentials( $key, $secret );
	}

	/**
	 * Check if the API configuration is valid.
	 *
	 * @return boolean
	 * @access protected
	 */
	protected function is_api_configuration_valid() {
		$api_key = $this->get_setting( 'api_key' );
		$api_secret = $this->get_setting( 'api_secret' );
		$api_channel = $this->get_setting( 'api_channel' );
		if ( empty( $api_key )
			|| empty( $api_secret )
			|| empty( $api_channel ) )
		{
			return false;
		}

		return true;
	}

}

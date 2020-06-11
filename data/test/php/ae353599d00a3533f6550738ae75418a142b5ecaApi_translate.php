<?php if ( ! defined('BASEPATH')) exit('No direct script access allowed');
/**
 * API Translate.
 *
 * @package api_translate
 * @author Michael Kovalskiy
 */

// ------------------------------------------------------------------------

/**
 * API Translate Driver
 *
 * @subpackage	Drivers
 */
class Api_translate extends CI_Driver_Library {

	/**
	 * valid drivers
	 *
	 * @var array
	 */
	public $valid_drivers = array('api_translate_yandex', 'api_translate_bing','api_translate_google','api_translate_mymemory');

	// ------------------------------------------------------------------------

	/**
	 * Construct
	 *
	 * Initialize params
	 *
	 * @return Api_translate
	 */
	public function __construct()
	{
		log_message('debug', 'Api_translate: Library initialized.');
	}
}
	
/* End of file Api_translate.php */
/* Location: ./application/libraries/Api_translate/Api_translate.php */
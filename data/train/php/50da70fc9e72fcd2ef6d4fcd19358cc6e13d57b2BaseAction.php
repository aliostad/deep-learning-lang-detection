<?php

namespace Fruity\Modules\Api;

abstract class BaseAction implements Action {

	/**
	 * API this action belongs to
	 *
	 * @var Api
	 */
	protected $api;

	public function __construct( Api $api ) {
		$this->api = $api;
	}

	/**
	 * By default return the array
	 *
	 * @param array $data
	 * @return array
	 */
	public function processResult( array $data ) {
		return $data;
	}

	/**
	 * Alias for Api::runAction
	 *
	 * @return mixed
	 */
	public function run() {
		return $this->api->runAction( $this );
	}
}

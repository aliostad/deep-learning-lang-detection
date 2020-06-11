<?php

namespace Mediawiki\Flow\Api\Service;

use Mediawiki\Api\MediawikiApi;
use Mediawiki\Api\SimpleRequest;
use Mediawiki\Flow\Api\DataModel\Topic;

class TopicCreator {

	/**
	 * @var MediawikiApi
	 */
	private $api;
	/**
	 * @param MediawikiApi $api
	 */
	public function __construct( MediawikiApi $api ) {
		$this->api = $api;
	}

	public function create( Topic $topic ) {
		$this->api->postRequest( new SimpleRequest(
			'flow',
			array(
				'submodule' => 'new-topic',
				'page' => $topic->getPageName(),
				'nttopic' => $topic->getHeader(),
				'ntcontent' => $topic->getContent(),
				'token' => $this->api->getToken()
			)
		) );
	}

}
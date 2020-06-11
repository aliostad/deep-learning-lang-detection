<?php

namespace EmailOnAcid\Tests;

use EmailOnAcid\ApiFactory;
use EmailOnAcid\Tests\Api;
use PHPUnit\Framework\TestCase;

class ApiFactoryTest extends TestCase
{
	public function testObject()
	{
		$api = $this->getInstance();

		$this->assertInstanceOf(Api::class, $api->createTestsApi());
		$this->assertInstanceOf(\EmailOnAcid\EmailTesting\Api::class, $api->createEmailTestingApi());
		$this->assertInstanceOf(\EmailOnAcid\SpamTesting\Api::class, $api->createSpamTestingApi());
		$this->assertInstanceOf(\EmailOnAcid\EmailClients\Api::class, $api->createEmailClientsApi());


	}

	private function getInstance(): ApiFactory
	{
		return new ApiFactory(
			'test',
			'test'
		);
	}

}

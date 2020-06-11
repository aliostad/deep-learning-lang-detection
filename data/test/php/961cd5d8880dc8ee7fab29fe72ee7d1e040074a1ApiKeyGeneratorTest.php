<?php

use crick\Security\Api\ApiKeyGenerator;

class ApiKeyGeneratorTest extends PHPUnit_Framework_TestCase
{
    protected $apiKey;
    protected $apiKey2;

    protected function setUp()
    {
        $this->apiKey = ApiKeyGenerator::generateKey();
        $this->apiKey2 = ApiKeyGenerator::generateKey();
    }

    public function testApiKeyNotNull()
    {
        $this->assertNotNull($this->apiKey);
    }

    public function testApiKeyCount()
    {
        $this->assertEquals(60, strlen($this->apiKey));
        $this->assertEquals(60, strlen($this->apiKey2));
    }

    public function testApiKeyNotEqual()
    {
        $this->assertNotEquals($this->apiKey, $this->apiKey2);
    }
}

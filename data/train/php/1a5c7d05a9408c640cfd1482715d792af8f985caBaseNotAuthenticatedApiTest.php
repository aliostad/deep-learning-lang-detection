<?php

namespace Tests\Api;

use LastFmApi\Api\AuthApi;

/**
 * Base class for api tests
 *
 * @author Marcos Peña
 */
abstract class BaseNotAuthenticatedApiTest extends BaseApiTest
{

    protected $authentication;
    private $isApiInitiated = false;
    
    public function initiateApi()
    {
        $this->setUp();
        if (empty($this->apiKey)) {
            $this->fail("You must provide a valid apiKey!");
        }
        $this->authentication = new AuthApi('setsession', array('apiKey' => $this->apiKey));
        $this->isApiInitiated = true;
    }

    public function isApiInitiated()
    {
        return $this->isApiInitiated;
    }

}

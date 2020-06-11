<?php

namespace RJP\ApiBundle\Controller;

use FOS\RestBundle\Controller\FOSRestController;

/**
 * Class ApiController
 * @package RJP\ApiBundle\Controller
 */
class ApiController extends FOSRestController
{
    /**
     * @var \RJP\ApiBundle\Services\Api
     */
    protected $api;

    /**
     * @return \RJP\ApiBundle\Services\Api
     */
    public function getApi()
    {
        return $this->api;
    }

    /**
     * Sets the API service in the controller
     *
     * @param \RJP\ApiBundle\Services\Api $api
     */
    public function setApi(\RJP\ApiBundle\Services\Api $api)
    {
        $this->api = $api;
    }
}
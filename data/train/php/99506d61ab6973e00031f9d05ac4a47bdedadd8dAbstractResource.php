<?php

namespace Dyn\MessageManagement\Api\Resource;

use Dyn\MessageManagement\Api\Client as ApiClient;

abstract class AbstractResource
{
    /**
     * The API client instance, used for all API communication
     *
     * @var ApiClient
     */
    protected $apiClient;


    public function __construct(ApiClient $apiClient)
    {
        $this->setApiClient($apiClient);
    }

    /**
     * Setter for API client
     *
     * @param ApiClient $apiClient
     */
    public function setApiClient(ApiClient $apiClient)
    {
        $this->apiClient = $apiClient;

        return $this;
    }

    /**
     * Getter for API client instance
     *
     * @return ApiClient
     */
    public function getApiClient()
    {
        return $this->apiClient;
    }
}

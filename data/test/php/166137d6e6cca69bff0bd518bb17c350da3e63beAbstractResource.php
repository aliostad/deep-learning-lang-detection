<?php

namespace Dyn\MessageManagement\Api;

abstract class AbstractResource
{
    /**
     * The API client instance, used for all API communication
     *
     * @var ApiClient
     */
    protected $apiClient;


    public function __construct(Client $apiClient)
    {
        $this->setApiClient($apiClient);
    }

    /**
     * Setter for API client
     *
     * @param Client $apiClient
     */
    public function setApiClient(Client $apiClient)
    {
        $this->apiClient = $apiClient;

        return $this;
    }

    /**
     * Getter for API client instance
     *
     * @return Client
     */
    public function getApiClient()
    {
        return $this->apiClient;
    }
}

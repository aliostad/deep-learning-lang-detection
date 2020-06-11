<?php

namespace Alitvinenko\GoogleApiBundle;

use Alitvinenko\GoogleApiBundle\Api\Language;
use Alitvinenko\GoogleApiBundle\Exception\ApiException;
use Alitvinenko\GoogleApiBundle\HttpClient\HttpClient;

class GoogleApi
{
    protected $client;

    public function __construct($apiKey)
    {
        $this->client = new HttpClient($apiKey);
    }

    public function api($name)
    {
        switch ($name) {
            case 'language':
                $api = new Language($this->client);
                return $api;
        }

        throw new ApiException('Api manager name is incorrect');
    }

    public function getLanguage()
    {
        return $this->api('language');
    }
}
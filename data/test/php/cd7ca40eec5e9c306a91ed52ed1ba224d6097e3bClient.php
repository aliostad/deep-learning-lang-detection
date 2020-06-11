<?php

namespace Openstate;

use Openstate\Api;

class Client
{
    public $apiKey;

    public function __construct($apiKey)
    {
        $this->apiKey = $apiKey;
    }

    /**
     * Returns requested Api object
     *
     * @param  string   $api
     * @return Api
     **/
    public function api($api)
    {
        switch ($api) {
            case 'bill':
                $api = new Api\Bill($this);
                break;

            case 'legislator':
                $api = new Api\Legislator($this);
                break;

            case 'committee':
                $api = new Api\Committee($this);
                break;

            case 'event':
                $api = new Api\Event($this);
                break;
            
            default:
                 throw new Exception(sprintf('Invalid API Called: "%s"', $name));
                break;
        }

        return $api;
    }
}

<?php namespace Minedun\LolApi;

use \Config;
use LeagueWrap\Api;


class Lol
{

    /**
     * @var ApiKey
     */
    private $_apiKey;

    /**
     * Constructor
     */
    public function __construct()
    {
        if (Config::get('lolapi.api_key') != null)
            $this->_apiKey = Config::get('lolapi.api_key');
        else
            $this->_apiKey = Config::get('lolapi::api_key');
    }

    /**
     * Construct the Api object and returns it
     * ApiKey can be overridden by passing in an argument
     *
     * @param string $apiKey
     * @return Api
     */
    public function Api($apiKey = null)
    {
        if (isset($apiKey))
            $this->_apiKey = $apiKey;
        return new Api($this->_apiKey);
    }
}
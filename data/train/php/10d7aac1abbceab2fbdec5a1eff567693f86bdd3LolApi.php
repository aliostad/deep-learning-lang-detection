<?php namespace Josephting\LolApi;

use Illuminate\Support\ServiceProvider;

use \Config;

use LeagueWrap\Api;

class LolApi {
    /**
     * @var ApiKey
     */
    private $_apiKey;

    /**
     * Constructor
     */
    public function __construct()
    {
        if (Config::get('lolapi-4-laravel.api_key') != null)
            $this->_apiKey = Config::get('lolapi-4-laravel.api_key');
        else
            $this->_apiKey = Config::get('lolapi-4-laravel::api_key');
    }

    /**
     * Construct the Api object and returns it
     * ApiKey can be overridden by passing in an argument
     *
     * @param string $apiKey
     * @return Api
     */
    public function Api($apiKey=null)
    {
        if (isset($apiKey))
            $this->_apiKey = $apiKey;

        return new Api($this->_apiKey);
    }
}
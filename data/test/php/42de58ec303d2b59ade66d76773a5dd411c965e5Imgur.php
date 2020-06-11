<?php
namespace Fastur\Helper;

class Imgur {

    protected $api_key = "";
    protected $api_secret = "";
    protected $api_endpoint = "https://api.imgur.com/3";
    protected $connection;

    public function __construct($api_key, $api_secret) {

        // If api key and secret are not injected.
        if (!$api_key || !$api_secret) {
            throw Exception("Missing API key and secret.");
        }

        $this->api_key = $api_key;
        $this->api_secret = $api_secret;
        $this->connection = new Connect($this->api_key, $this->api_secret);
    }

    public function upload() {
        return new Upload($this->connection, $this->api_endpoint);
    }
}
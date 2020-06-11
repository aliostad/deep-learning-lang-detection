<?php

// FoletaApiClient
class FoletaApiClient {
    
    // Api address
    var $apiAddress;


    // Api key
    var $apiKey;


    // Constructor
    function __construct($apiAddress, $apiKey) {
        $this->apiAddress = $apiAddress;
        $this->apiKey = $apiKey;
    }

    
    // Get
    public function get($url) {
        
        $curl = curl_init();
        curl_setopt($curl, CURLOPT_HTTPHEADER,array('X-Foleta-ApiKey : ' . $this->apiKey));

        curl_setopt($curl, CURLOPT_URL, $this->apiAddress . $url);
        curl_setopt($curl, CURLOPT_RETURNTRANSFER, 1);

        $result = curl_exec($curl);
        curl_close($curl);

        return json_decode($result);
    }
}

?>
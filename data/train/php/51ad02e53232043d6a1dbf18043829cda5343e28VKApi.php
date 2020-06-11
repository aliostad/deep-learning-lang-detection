<?php
namespace VKApi;

class VKApi {
    
    /**
     * Your app API key
     * 
     * @var string
     */
    protected $apiKey = null;
    
    /**
     * Your app secret
     * 
     * @var string
     */
    protected $apiSecret = null;
    
    /**
     * Access token for current user
     * 
     * @var string
     */
    protected $accessToken = null;
    
    /**
     * Constructor
     * 
     * @var string $apiKey
     * @var string $apiSecret
     */
    public function __construct($apiKey=null, $apiSecret=null) {
        $this->setApiKey($apiKey);
        $this->setApiSecret($apiSecret);
    }
    
    /**
     * Sets app API key
     * 
     * @param string $apiKey
     * @return VKApi
     */
    public function setApiKey($apiKey) {
        $this->apiKey = $apiKey;
        return $this;
    }
    
    /**
     * Returns app API key
     * 
     * @return string
     */
    public function getApiKey() {
        return $this->apiKey;
    }
    
    /**
     * Sets app API secret
     * 
     * @param string $apiSecret
     * @return VKApi
     */
    public function setApiSecret($apiSecret) {
        $this->apiSecret = $apiSecret;
        return $this;
    }
    
    /**
     * Returns app API secret
     * 
     * @param string $apiSecret
     * @return string
     */
    public function getApiSecret($apiSecret) {
        $this->apiSecret = $apiSecret;
    }
    
}
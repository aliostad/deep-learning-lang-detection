<?php
namespace Hyperion\Scribe\Builder;

use Hyperion\Scribe\Builder\Api\Api;
use Hyperion\Scribe\Model\OAuthConfig;
use Hyperion\Scribe\Model\OAuthConstants;
use Hyperion\Scribe\Model\SignatureType;
use Hyperion\Scribe\Utils\Preconditions;

class ServiceBuilder
{
    private $apiKey;
    private $apiSecret;
    private $callback;
    private $api;
    private $scope;
    private $signatureType = SignatureType::HEADER;

    public function __construct()
    {
        $this->callback = OAuthConstants::OUT_OF_BAND;
    }

    public function provider($apiClass)
    {
        if ($apiClass instanceof Api) {
            $this->_provider($apiClass);
        } else if (is_string($apiClass)) {
            $this->api = $this->createApi($apiClass);
        }
        return $this;
    }

    private function _provider(Api $api)
    {
        Preconditions::checkNotNull($api, "Api cannot be null");
        $this->api = $api;
        return $this;
    }

    private function createApi($apiClass)
    {
        Preconditions::checkEmptyString($apiClass, "Api class cannot be empty");
        $api = null;
        try {
            $api = new $apiClass();
        } catch (\Exception $e) {
            throw new \OAuthException("Error while creating the Api object", $e);
        }
        return $api;
    }

    public function callback($callback)
    {
        Preconditions::checkValidOAuthCallback($callback, "Callback must be a valid URL or 'oob'");
        $this->callback = $callback;
        return $this;
    }

    public function apiKey($apiKey)
    {
        Preconditions::checkEmptyString($apiKey, "Invalid Api key");
        $this->apiKey = $apiKey;
        return $this;
    }

    public function apiSecret($apiSecret)
    {
        Preconditions::checkEmptyString($apiSecret, "Invalid Api secret");
        $this->apiSecret = $apiSecret;
        return $this;
    }

    public function scope($scope)
    {
        Preconditions::checkEmptyString($scope, "Invalid OAuth scope");
        $this->scope = $scope;
        return $this;
    }

    public function signatureType($type)
    {
        Preconditions::checkNotNull($type, "Signature type can't be null");
        $this->signatureType = $type;
        return $this;
    }

    public function build()
    {
        Preconditions::checkNotNull($this->api, "You must specify a valid api through the provider() method");
        Preconditions::checkEmptyString($this->apiKey, "You must provide an api key");
        Preconditions::checkEmptyString($this->apiSecret, "You must provide an api secret");
        return $this->api->createService(new OAuthConfig($this->apiKey, $this->apiSecret, $this->callback, $this->signatureType, $this->scope));
    }
}
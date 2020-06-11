<?php

namespace CdiTools\Service;

/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

use CdiTools\Options\GoogleApiOptionsInterface;

/**
 * Description of GoogleApi
 *
 * @author cincarnato
 */
abstract class AbstractGoogleApi {

    //put your code here

    protected $apiId;
    protected $apiEmail;
    protected $apiKeyFile;
    protected $apiApplicationName;
    protected $apiAccessType = 'offline_access';
    protected $apiScopes = array();
    protected $apiPrivateKeyPassword;
    protected $client;
    protected $creds;
    protected $service;

    function __construct(GoogleApiOptionsInterface $options) {

        $this->apiId = $options->getApiId();
        $this->apiEmail = $options->getApiEmail();
        $this->apiKeyFile = $options->getApiKeyFile();
        $this->apiApplicationName = $options->getApiApplicationName();
        $this->apiAccessType = $options->getApiAccessType();
        $this->apiScopes = $options->getApiScopes();
        $options->apiPrivateKeyPassword = $options->getApiPrivateKeyPassword();
        // var_dump( $this->apiId);

        $this->client = new \Google_Client();
        $this->client->setApplicationName($this->apiApplicationName);
        $this->creds = new \Google_Auth_AssertionCredentials($this->apiEmail, $this->apiScopes, file_get_contents($this->apiKeyFile), $options->apiPrivateKeyPassword);
        $this->client->setAssertionCredentials($this->creds);
        $this->client->setClientId($this->apiId);
        $this->client->setAccessType($this->apiAccessType);
        
    }

    public function getApiId() {
        return $this->apiId;
    }

    public function setApiId($apiId) {
        $this->apiId = $apiId;
    }

    public function getApiEmail() {
        return $this->apiEmail;
    }

    public function setApiEmail($apiEmail) {
        $this->apiEmail = $apiEmail;
    }

    public function getApiKeyFile() {
        return $this->apiKeyFile;
    }

    public function setApiKeyFile($apiKeyFile) {
        $this->apiKeyFile = $apiKeyFile;
    }

    public function getApiApplicationName() {
        return $this->apiApplicationName;
    }

    public function setApiApplicationName($apiApplicationName) {
        $this->apiApplicationName = $apiApplicationName;
    }

    public function getApiAccessType() {
        return $this->apiAccessType;
    }

    public function setApiAccessType($apiAccessType) {
        $this->apiAccessType = $apiAccessType;
    }

    public function getClient() {
        return $this->client;
    }

    public function getApiScopes() {
        return $this->apiScopes;
    }

    public function setApiScopes($apiScopes) {
        $this->apiScopes = $apiScopes;
    }

    public function getApiPrivateKeyPassword() {
        return $this->apiPrivateKeyPassword;
    }

    public function setApiPrivateKeyPassword($apiPrivateKeyPassword) {
        $this->apiPrivateKeyPassword = $apiPrivateKeyPassword;
    }
    public function getService() {
        return $this->service;
    }

    public function setService($service) {
        $this->service = $service;
    }



}

?>

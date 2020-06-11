<?php

class ApiJson extends ApiRequest
{

    public function __construct()
    {}

    function __destruct()
    {}

    /**
     *
     * {@inheritdoc}
     *
     * @see ApiRequest::parse()
     */
    public function parse()
    {
        $json = $_POST[ApiRequest::BOI_API];
        
        $this->api_body = json_decode($json);
        $this->api_code = strtolower($this->api_body->{ApiRequest::API_CODE});
    }

    /**
     *
     * {@inheritdoc}
     *
     * @see ApiRequest::getApiCode()
     */
    public function getApiCode()
    {
        return (is_string($this->api_code)) ? $this->api_code : null;
    }

    /**
     *
     * {@inheritdoc}
     *
     * @see ApiRequest::getApiParameter()
     */
    public function getApiParameter()
    {
        return (is_null($this->api_body)) ? $this->api_body : null;
    }
}


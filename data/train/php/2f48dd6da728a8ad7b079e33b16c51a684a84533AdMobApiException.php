<?php

class AdMobApiException extends Exception
{
  private $api_url;
  private $api_parameters;
  private $api_response;

  public function setApiUrl($api_url)
  {
    $this->api_url = $api_url;
    $this->message .= " [URL {$this->api_url}]";
  }

  public function setApiParameters($api_parameters)
  {
    if (isset($api_parameters['password'])) {
      $api_parameters['password'] = '';
    }

    $this->api_parameters = $api_parameters;
    $parameter_string = http_build_query($api_parameters);
    $this->message .= " [PARAMETERS $parameter_string]";;
  }

  public function setApiResponse($api_response)
  {
    $this->api_response = $api_response;

    foreach ($api_response['errors'] as $error) {
      $this->message .= " [ERROR {$error['code']} {$error['msg']}]";
    }

    foreach ($api_response['warnings'] as $warning) {
      $this->message .= " [WARNING {$warning['code']} {$warning['msg']}]";
    }
  }

  public function getApiUrl()
  {
    return $this->api_url;
  }

  public function getApiParameters()
  {
    return $this->api_parameters;
  }

  public function getApiResponse()
  {
    return $this->api_response;
  }
}
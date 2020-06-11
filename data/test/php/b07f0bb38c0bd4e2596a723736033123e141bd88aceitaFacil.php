<?php

abstract class aceitaFacil {
  /**
   * @var string aF API key to be used for requests.
   */
  public static $apiKey;
  /**
   * @var string aF API secret to be used for requests.
   */
  public static $apiSecret;
  /**
   * @var string The base URL for the aF API.
   */
  public static $apiBase = 'https://sandbox.api.aceitafacil.com/';
  /**
   * @var string The base URL for the aF API.
   */
  public static $sandbox = false;

  /**
   * @return string The API key used for requests.
   */
  public static function getApiKey() {
    return self::$apiKey;
  }

  /**
   * @return string The API secret used for requests.
   */
  public static function getApiSecret() {
    return self::$apiSecret;
  }

  /**
   * Sets the API key to be used for requests.
   *
   * @param string $apiKey
   */
  public static function setApiKey($apiKey) {
    self::$apiKey = $apiKey;
  }

  /**
   * Sets the API secret to be used for requests.
   *
   * @param string $apiSecret
   */
  public static function setApiSecret($apiSecret) {
    self::$apiSecret = $apiSecret;
  }

  /**
   * Sets the API key and secret to be used for requests.
   *
   * @param string $apiKey
   */
  public static function setApiKeys($apiKey, $apiSecret) {
    self::setApiKey($apiKey);
    self::setApiSecret($apiSecret);
  }

  /**
   * Sets the environment to be used for requests.
   *
   * @param string $env [production/sandbox]
   */
  public static function setEnv($env) {
    if(strtolower($env) == 'production') {
      self::$apiBase = 'https://api.aceitafacil.com/';
    } else {
      self::$apiBase = 'https://sandbox.api.aceitafacil.com/';
    }
  }

}

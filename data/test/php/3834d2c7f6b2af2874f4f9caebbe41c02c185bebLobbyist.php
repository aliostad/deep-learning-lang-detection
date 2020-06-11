<?php

abstract class Lobbyist
{
  public static $apiKey;
  public static $apiSecret;
  public static $apiBase = 'http://api.customerlobby.com';
  public static $apiVersion = null;

  public static function getApiKey()
  {
    return self::$apiKey;
  }

  public static function setApiKey($apiKey)
  {
    self::$apiKey = $apiKey;
  }

  public static function getApiSecret()
  {
    return self::$apiSecret;
  }

  public static function setApiSecret($apiSecret)
  {
    self::$apiSecret = $apiSecret;
  }

  public static function getApiVersion()
  {
    return self::$apiVersion;
  }

  public static function setApiVersion($apiVersion)
  {
    self::$apiVersion = $apiVersion;
  }

  public static function setApiBase($apiBase)
  {
    self::$apiBase = $apiBase;
  }
}

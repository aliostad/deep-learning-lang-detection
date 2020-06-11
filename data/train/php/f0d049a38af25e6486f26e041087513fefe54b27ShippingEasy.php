<?php

abstract class ShippingEasy
{
  public static $apiKey;
  public static $apiSecret;
  public static $apiBase = 'https://app.shippingeasy.com';
  public static $apiVersion = null;
  const VERSION = '0.3.0';

  public static function getApiKey()
  {
    return self::$apiKey;
  }

  public static function setApiKey($apiKey)
  {
    self::$apiKey = $apiKey;
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

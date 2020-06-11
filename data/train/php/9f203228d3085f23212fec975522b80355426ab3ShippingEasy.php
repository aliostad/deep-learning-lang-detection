<?php

abstract class ShippingEasy
{
  public static $apiKey;
  public static $apiSecret;
  public static $partnerApiKey;
  public static $partnerApiSecret;
  public static $apiBase = 'https://app.shippingeasy.com';
  public static $apiVersion = null;
  const VERSION = '0.4.0';

  public static function getApiKey()
  {
    return self::$apiKey;
  }

  public static function setApiKey($apiKey)
  {
    self::$apiKey = $apiKey;
  }

  public static function getPartnerApiKey()
    {
      return self::$partnerApiKey;
    }

  public static function setPartnerApiKey($partnerApiKey)
  {
    self::$partnerApiKey = $partnerApiKey;
  }

  public static function setApiSecret($apiSecret)
  {
    self::$apiSecret = $apiSecret;
  }

  public static function setPartnerApiSecret($partnerApiSecret)
  {
    self::$partnerApiSecret = $partnerApiSecret;
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

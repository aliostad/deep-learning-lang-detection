<?php

class SAM_List extends SAM_Object
{
  public static function constructFrom($values, $apiKey=null, $apiSecret=null)
  {
    $class = get_class();
    return self::scopedConstructFrom($class, $values, $apiKey, $apiSecret);
  }

  public function all($params=null)
  {
    $requestor = new SAM_ApiRequestor($this->_apiKey, $this->_apiSecret);
    list($response, $apiKey, $apiSecret) = $requestor->request('get', $this['url'], $params);
    return SAM_Util::convertToSAMObject($response, $apiKey, $apiSecret);
  }

  public function create($params=null)
  {
    $requestor = new SAM_ApiRequestor($this->_apiKey, $this->_apiSecret);
    list($response, $apiKey, $apiSecret) = $requestor->request('post', $this['url'], $params);
    return SAM_Util::convertToSAMObject($response, $apiKey, $apiSecret);
  }

  public function retrieve($id, $params=null)
  {
    $requestor = new SAM_ApiRequestor($this->_apiKey, $this->_apiSecret);
    $base = $this['url'];
    $id = SAM_ApiRequestor::utf8($id);
    $extn = urlencode($id);
    list($response, $apiKey, $apiSecret) = $requestor->request('get', "$base/$extn", $params);
    return SAM_Util::convertToSAMObject($response, $apiKey, $apiSecret);
  }

}

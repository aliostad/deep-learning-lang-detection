<?php
namespace Nora\Network\API\Facebook;

use Nora\Base\Event;
use Nora\Network\API;
use Nora\Base\Component\Component;
use Nora\Util\Util;
use Nora;

/**
 * Facebook API  Consumer Helper
 */
class Consumer 
{
    private $_facade;
    private $_consumer;

    public function __construct(Facade $facade, API\OAuth\Consumer $consumer)
    {
        $this->_consumer = $consumer;
        $this->_facade = $facade;
    }

    public function requestTokenUrl($callback, $scope = ['email','user_likes'])
    {
        return $this->_facade->oauth()->requestTokenUrl($this->_consumer, $callback, $scope);
    }

    public function accessToken($code, $callback)
    {
        return $this->_facade->oauth()->accessToken($this->_consumer, $code, $callback);
    }

    public function helper($token)
    {
        return new Helper($this->_facade, $this->_consumer, $this->_facade->token($token));
    }

}

<?php


namespace Arandel\OtrsRpcClient;

use Arandel\OtrsRpcClient\Api\ConfigApi;
use Arandel\OtrsRpcClient\Api\CustomerCompanyApi;
use Arandel\OtrsRpcClient\Api\CustomerUserApi;
use Arandel\OtrsRpcClient\Api\EncodeApi;
use Arandel\OtrsRpcClient\Api\GroupApi;
use Arandel\OtrsRpcClient\Api\LinkApi;
use Arandel\OtrsRpcClient\Api\LogApi;
use Arandel\OtrsRpcClient\Api\MainApi;
use Arandel\OtrsRpcClient\Api\PIDApi;
use Arandel\OtrsRpcClient\Api\QueueApi;
use Arandel\OtrsRpcClient\Api\SessionApi;
use Arandel\OtrsRpcClient\Api\TicketApi;
use Arandel\OtrsRpcClient\Api\TimeApi;
use Arandel\OtrsRpcClient\Api\UserApi;

class OtrsClient
{

    /** @var RpcClient */
    protected $client;
    private $user;
    private $pass;

    private $apis = [];

    public function __construct($user, $pass, $url)
    {
        $this->user = $user;
        $this->pass = $pass;
        $this->url = $url;

        $this->client = new RpcClient($this->url, $this->user, $this->pass);
    }

    /** @return RpcClient */
    private function getClient()
    {
        return $this->client;
    }

    /** @return TicketApi */
    public function getTicketApi()
    {
        return $this->getApi('TicketApi');
    }

    /** @return SessionApi */
    public function getSessionApi()
    {
        return $this->getApi('SessionApi');
    }

    /** @return UserApi */
    public function getUserApi()
    {
        return $this->getApi('UserApi');
    }

    /** @return ConfigApi */
    public function getConfigApi()
    {
        return $this->getApi('ConfigApi');
    }

    /** @return QueueApi */
    public function getQueueApi()
    {
        return $this->getApi('QueueApi');
    }

    /** @return LogApi */
    public function getLogApi()
    {
        return $this->getApi('LogApi');
    }

    /** @return CustomerUserApi */
    public function getCustomerUserApi()
    {
        return $this->getApi('CustomerUserApi');
    }

    /** @return TimeApi */
    public function getTimeApi()
    {
        return $this->getApi('TimeApi');
    }

    /** @return GroupApi */
    public function getGroupApi()
    {
        return $this->getApi('GroupApi');
    }

    /** @return LinkApi */
    public function getLinkApi()
    {
        return $this->getApi('LinkApi');
    }

    /** @return PIDApi */
    public function getPIDApi()
    {
        return $this->getApi('PIDApi');
    }

    /** @return MainApi */
    public function getMainApi()
    {
        return $this->getApi('MainApi');
    }

    /** @return EncodeApi */
    public function getEncodeApi()
    {
        return $this->getApi('EncodeApi');
    }

    /** @return CustomerCompanyApi */
    public function getCustomerCompanyApi()
    {
        return $this->getApi('CustomerCompanyApi');
    }

    private function getApi($name)
    {
        if (!isset($this->apis[$name])) {
            $this->apis[$name] = new $name($this->getClient(), $this);
        }
        return $this->apis[$name];
    }
}

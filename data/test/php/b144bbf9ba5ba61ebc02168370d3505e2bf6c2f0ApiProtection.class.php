<?php

namespace DesignPatterns\Structural\ProtectionProxy;

/**
 * Class ApiProtection
 * @package DesignPatterns\Structural\ProtectionProxy
 */
class ApiProtection extends Api
{

    /**
     * @var int
     */
    protected $count = 0;

    /**
     * @var API
     */
    private $api;

    /**
     * @param API $api
     * @param $limit
     */
    public function __construct(API $api, $limit)
    {
        $this->api = $api;
        $this->limit = $limit;
    }

    /**
     *
     */
    public function doStuff()
    {
        $this->count();
        return $this->api->doStuff();
    }

    /**
     * @throws RemoteApiLimit
     */
    private function count()
    {
        if (++$this->count > $this->limit) {
            throw new RemoteApiLimit('STOP!');
        }
    }
}

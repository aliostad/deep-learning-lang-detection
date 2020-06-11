<?php

namespace Starbonus\Api\Service;

use Starbonus\Api\Api;

/**
 * Class AbstractService
 *
 * @author Adam Kuśmierz <adam@kusmierz.be>
 * @package Starbonus\Api\Service
 */
abstract class AbstractService implements ServiceInterface
{

    /**
     * @var \Starbonus\Api\Api
     */
    private $api;

    /**
     * @var \Zend\Stdlib\Hydrator\AbstractHydrator
     */
    protected $hydrator;

    /**
     * @param \Starbonus\Api\Api $api
     */
    public function __construct(Api $api)
    {
        $this->api = $api;
    }

    /**
     * @return \OAuth\Common\Service\ServiceInterface
     */
    protected function getApiInstance()
    {
        return $this->api->getApiInstance();
    }

    /**
     * @return \Zend\Stdlib\Hydrator\AbstractHydrator
     */
    protected function getHydrator()
    {
        return $this->hydrator;
    }

    /**
     * @param \Zend\Stdlib\Hydrator\AbstractHydrator $hydrator
     *
     * @return $this
     */
    public function setHydrator($hydrator)
    {
        $this->hydrator = $hydrator;

        return $this;
    }
}

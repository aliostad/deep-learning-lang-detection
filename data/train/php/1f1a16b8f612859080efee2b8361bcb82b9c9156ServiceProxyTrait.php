<?php

namespace WbBase\WbTrait\Service;

use WbBase\Service\ServiceInterface;

/**
 * ServiceProxyTrait
 *
 * @package WbBase\WbTrait\Service
 * @author  Źmicier Hryškieivič <zmicier@webbison.com>
 */
trait ServiceProxyTrait
{

    /**
     * @var ServiceInterface
     */
    protected $service;

    /**
     * Service setter
     *
     * @param ServiceInterface $service Service instance.
     *
     * @return void
     */
    public function setService(ServiceInterface $service)
    {
        $this->service = $service;

        return $this;
    }

    /**
     * Service getter
     *
     * @return ServiceInterface
     */
    public function getService()
    {
        return $this->service;
    }
}

<?php

namespace Dibber\Service;

/**
 * A trait for objects that provide service
 */
trait ServiceAwareTrait
{
    /**
     * @var
     */
    protected $service;

    /**
     * @todo ? User service extends ZfcUserService thus prevent us from having
     * a common base of service here in dibber.
     *
     * @param Base $service
     * @return mixed
     */
    public function setService($service)
    {
        $this->service = $service;
        return $this;
    }

    /**
     * @return Base
     */
    public function getService()
    {
        return $this->service;
    }
}
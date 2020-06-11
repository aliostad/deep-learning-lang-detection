<?php

namespace Meta;

class ServiceAware implements ServiceAwareInterface
{
    /**
     * @var service
     */
    private $service;

    final public function getService()
    {
        return $this->service;
    }

    /**
     * Set service
     *
     * @param Service $service
     */
    final public function setService(Service $service)
    {
        if (null !== $this->service) {
            if ($this->service !== $service) {
                throw new \LogicException("Cannot change service");
            }
        } else {
            $this->service = $service;
        }
    }
}

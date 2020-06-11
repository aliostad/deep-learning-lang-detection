<?php

namespace Itkg\Consumer\Event;

use Itkg\Consumer\Service\Service;
use Itkg\Consumer\Service\ServiceInterface;
use Symfony\Component\EventDispatcher\Event;

/**
 * Class ServiceEvent
 *
 * Service Event used for ServiceEvents dispatch
 *
 * @package Itkg\Consumer\Event
 */
class ServiceEvent extends Event
{
    /**
     * @var Service
     */
    private $service;

    /**
     * @param ServiceInterface $service
     */
    public function __construct(ServiceInterface $service)
    {
        $this->service = $service;
    }
    /**
     * Get service
     *
     * @return ServiceInterface
     */
    public function getService()
    {
        return $this->service;
    }
}

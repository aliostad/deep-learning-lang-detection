<?php

namespace Reliv\Deploy\EventSubscriber;

use Reliv\Deploy\Service\ConfigService;
use Symfony\Component\EventDispatcher\EventSubscriberInterface;

abstract class EventSubscriberAbstract implements EventSubscriberInterface
{
    /**
     * @var ConfigService
     */
    protected $configService;


    /**
     * Set the Reliv Config Service
     *
     * @param ConfigService $configService Reliv Deploy Config Service
     *
     * @return void
     */
    public function setConfigService(ConfigService $configService)
    {
        $this->configService = $configService;
    }

    /**
     * Get the Reliv Deploy Config Service
     *
     * @return ConfigService
     */
    public function getConfigService()
    {
        return $this->configService;
    }
}

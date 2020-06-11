<?php

namespace Application\View\Helper;

use Zend\View\Helper\AbstractHelper;

use Application\Service\Legacy as LegacyService;

class Infima extends AbstractHelper
{

    /**
     * Legacy service
     *
     * @var LegacyService
     */
    protected $legacyService;

    /**
     * Get an infima.
     *
     * @return string
     */
    public function __invoke()
    {
        return $this->getLegacyService()->getInfima();
    }

    /**
     * Get the legacy service.
     *
     * @return LegacyService
     */
    public function getLegacyService()
    {
        return $this->legacyService;
    }

    /**
     * Set the legacy service locator
     *
     * @param LegacyService $service
     */
    public function setLegacyService(LegacyService $service)
    {
        $this->legacyService = $service;
    }
}

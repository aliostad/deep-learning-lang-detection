<?php

namespace RayzorAnalytics\Service\Feature;

use RayzorAnalytics\Service\AnalyticsService;
use Zend\Stdlib\Exception\LogicException;

trait AnalyticsServiceAwareTrait
{
    /**
     * @var AnalyticsService
     */
    protected $analyticsService;

    /**
     * @param AnalyticsService $analyticsService
     */
    public function setAnalyticsService(AnalyticsService $analyticsService)
    {
        $this->analyticsService = $analyticsService;
    }

    /**
     * @return AnalyticsService
     * @throws \Zend\Stdlib\Exception\LogicException
     */
    public function getAnalyticsService()
    {
        if (null === $this->analyticsService) {
            throw new LogicException('User service must be defined');
        }

        return $this->analyticsService;
    }
}

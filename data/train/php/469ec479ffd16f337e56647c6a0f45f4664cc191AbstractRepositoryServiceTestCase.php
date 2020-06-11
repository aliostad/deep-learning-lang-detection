<?php

namespace Edge\Test;

use Edge\Service\AbstractRepositoryService;

abstract class AbstractRepositoryServiceTestCase extends AbstractTestCase
{
    /**
     * @var AbstractRepositoryService
     */
    private $service;

    /**
     * Set the current service
     *
     * @param AbstractRepositoryService $service
     */
    protected function setService(AbstractRepositoryService $service)
    {
        $this->service = $service;
    }

    /**
     * Get the current service
     *
     * @return AbstractRepositoryService
     */
    protected function getService()
    {
        return $this->service;
    }

    public function tearDown()
    {
        parent::tearDown();
        unset($this->service);
    }
}
<?php
/**
 * @author stev leibelt <artodeto@bazzline.net>
 * @since 2014-03-27 
 */

namespace Controller;

use Service\Locator;

class AbstractController
{
    /**
     * @var \Service\Locator
     */
    private $locator;

    public function __construct()
    {
        $this->locator = new Locator();
    }

    /**
     * @return \Service\DatabaseLocator
     */
    protected function getDatabaseLocator()
    {
        return $this->locator->getDatabaseLocator();
    }

    /**
     * @return \Model\Payload
     */
    protected function getPayload()
    {
        return $this->locator->getPayload();
    }
} 
<?php

namespace Orkestra\Bundle\GuzzleBundle;

use Orkestra\Bundle\GuzzleBundle\Services\Service;
use Orkestra\Bundle\GuzzleBundle\Services\ServiceContainer;
use Orkestra\Bundle\GuzzleBundle\Loader\ServiceLoader;

/**
 * Class to manage services created.
 *
 * @author Zach Badgett <zach.badgett@gmail.com>
 */
class Guzzle
{
    /**
     * @var array
     */
    private $serviceContainer;

    public function __construct($services, ServiceLoader $serviceLoader)
    {
        $this->serviceContainer = new ServiceContainer($serviceLoader);

        foreach ($services as $service) {
            $this->serviceContainer->addService($service);
        }
    }

    /**
     * Get service
     *
     * @param $service
     * @return \Orkestra\Bundle\GuzzleBundle\Services\Service
     */
    public function getService($service)
    {
        return $this->serviceContainer->getService($service);
    }
}

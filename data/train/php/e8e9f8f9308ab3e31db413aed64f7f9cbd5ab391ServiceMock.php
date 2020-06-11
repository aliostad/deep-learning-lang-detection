<?php
/**
 * @author Evgeny Shpilevsky <evgeny@shpilevsky.com>
 */

namespace EnliteMonologTest\Service;

use EnliteMonolog\Service\MonologServiceAwareInterface;
use Monolog\Logger;

class ServiceMock implements MonologServiceAwareInterface
{

    protected $service;

    /**
     * @param Logger $monologService
     * @return void
     */
    public function setMonologService(Logger $monologService)
    {
        $this->service = $monologService;
    }

    /**
     * @return Logger
     */
    public function getMonologService()
    {
        return $this->service;
    }
}

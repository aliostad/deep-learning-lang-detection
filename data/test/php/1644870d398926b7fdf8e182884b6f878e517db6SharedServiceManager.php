<?php

namespace Nano\Service;

use Nano\Service\ServiceManagerInterface;

class SharedServiceManager
{
    /**
     * @var ServiceManagerInterface
     */
    private static $sharedServiceManager;

    /**
     * @param \Nano\Service\ServiceManagerInterface $sharedServiceManager
     */
    public static function setSharedServiceManager($sharedServiceManager)
    {
        self::$sharedServiceManager = $sharedServiceManager;
    }

    /**
     * @return \Nano\Service\ServiceManagerInterface
     */
    public static function getSharedServiceManager()
    {
        return self::$sharedServiceManager;
    }
}
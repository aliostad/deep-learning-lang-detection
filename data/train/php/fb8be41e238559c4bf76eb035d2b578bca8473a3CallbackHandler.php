<?php
/**
 * Created by PhpStorm.
 * User: krona
 * Date: 4/22/14
 * Time: 5:56 PM
 */

namespace Arilas\Whoops\Handler;

use Zend\ServiceManager\ServiceLocatorInterface;

class CallbackHandler extends \Whoops\Handler\CallbackHandler
{
    /** @var  ServiceLocatorInterface */
    protected $locator;

    public function setServiceLocator(ServiceLocatorInterface $serviceLocator)
    {
        $this->locator = $serviceLocator;
    }

    public function getServiceLocator()
    {
        return $this->locator;
    }
} 
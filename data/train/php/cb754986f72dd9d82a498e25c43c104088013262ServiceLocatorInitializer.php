<?php
namespace SlidesWorker\ServiceLocator\Initializer;

use SlidesWorker\ServiceLocator\ServiceLocatorAwareInterface;
use SlidesWorkerTest\ServiceLocator\ServiceLocatorAwareTraitTest;
use SlidesWorker\ServiceLocator\ServiceLocatorInterface;

class ServiceLocatorInitializer implements InitializerInterface
{
    public function initialize($intance, ServiceLocatorInterface $locator)
    {
        if ($intance instanceof ServiceLocatorAwareInterface ||
            $intance instanceof ServiceLocatorAwareTraitTest
        ) {
            $intance->setServiceLocator($locator);
        }
    }
}

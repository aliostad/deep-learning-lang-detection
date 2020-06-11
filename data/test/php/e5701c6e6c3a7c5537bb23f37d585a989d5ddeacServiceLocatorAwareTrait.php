<?php
namespace SlidesWorker\ServiceLocator;

trait ServiceLocatorAwareTrait
{
    /**
     *
     * @var ServiceLocatorInterface
     */
    protected $serviceLocator;

    /**
     *
     * @param ServiceLocatorInterface $serviceLocator
     */
    public function setServiceLocator(ServiceLocatorInterface $serviceLocator)
    {
        $this->serviceLocator = $serviceLocator;
    }

    /**
     * @return ServiceLocatorInterface
     */
    public function getServiceLocator()
    {
        return $this->serviceLocator;
    }

}

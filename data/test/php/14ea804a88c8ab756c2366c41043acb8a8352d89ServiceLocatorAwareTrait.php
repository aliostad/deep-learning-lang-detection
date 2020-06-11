<?php

namespace Arrow\Service\Locator;

use Arrow\Service\Exception\ServiceException;

/**
 * Class ServiceLocatorAwareTrait
 *
 * @package Arrow\Service\Locator
 */
trait ServiceLocatorAwareTrait
{

    /**
     * @var ServiceLocatorInterface
     */
    protected $serviceLocator;

    /**
     * @inheritdoc
     */
    public function setServiceLocator(ServiceLocatorInterface $serviceLocator)
    {
        $this->serviceLocator = $serviceLocator;

        return $this;

    }

    /**
     * @inheritdoc
     */
    public function getServiceLocator()
    {

        if ($this->serviceLocator instanceof ServiceLocatorInterface === false) {

            throw new ServiceException('The service locator is not defined.');

        }

        return $this->serviceLocator;

    }

}
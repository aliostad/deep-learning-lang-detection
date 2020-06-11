<?php

namespace Arrow\Service\Locator;

use Arrow\Service\Exception\ServiceException;

/**
 * Interface ServiceLocatorAwareInterface
 *
 * @package Arrow\Service\Locator
 */
interface ServiceLocatorAwareInterface
{

    /**
     * @param ServiceLocatorInterface $serviceLocator
     * @return $this
     */
    public function setServiceLocator(ServiceLocatorInterface $serviceLocator);

    /**
     * @return ServiceLocatorInterface
     * @throws ServiceException
     */
    public function getServiceLocator();

}
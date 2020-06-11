<?php

namespace Detail\File\Factory\Repository;

use Zend\ServiceManager\ServiceLocatorInterface;

interface RepositoryFactoryInterface
{
    /**
     * Create repository.
     *
     * @param ServiceLocatorInterface $serviceLocator
     * @param string $name Repository name
     * @param array $config Repository config
     * @return \Detail\File\Repository\RepositoryInterface
     */
    public function createRepository(ServiceLocatorInterface $serviceLocator, $name, array $config);

    /**
     * Get repository class name.
     *
     * @return string
     */
    public function getRepositoryClass();
}

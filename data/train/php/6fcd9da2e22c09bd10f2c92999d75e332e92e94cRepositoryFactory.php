<?php
/**
 * RepositoryFactory
 *
 * @category  AxalianAchievementsDoctrine\ServiceFactory\Repository
 * @package   AxalianAchievementsDoctrine\ServiceFactory\Repository
 * @author    Michel Maas <michel@michelmaas.com>
 */

namespace AxalianAchievementsDoctrine\ServiceFactory\Repository;

use Zend\ServiceManager\AbstractFactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;

class RepositoryFactory implements AbstractFactoryInterface
{
    /**
     * {@inheritDoc}
     */
    public function canCreateServiceWithName(ServiceLocatorInterface $serviceLocator, $name, $requestedName)
    {
        return (strpos($requestedName, '\\Repository\\') !== false);
    }

    /**
     * {@inheritDoc}
     */
    public function createServiceWithName(ServiceLocatorInterface $serviceLocator, $name, $requestedName)
    {
        $entityClass = $this->getEntityClassName($requestedName);
        $repository = $serviceLocator->get('doctrine.entitymanager.orm_default')->getRepository($entityClass);

        return $repository;
    }

    /**
     * Get the entity class name of a repository class name
     *
     * @param  string $repositoryClass
     * @return string
     */
    protected function getEntityClassName($repositoryClass)
    {
        $repositoryClass = str_replace('\\Repository\\', '\\Entity\\', $repositoryClass);
        $repositoryClass =
            (substr($repositoryClass, -10) === 'Repository') ?
            substr($repositoryClass, 0, -10) :
            $repositoryClass;

        return $repositoryClass;
    }
}

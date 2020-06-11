<?php
/**
 * @category Kevin Kucera
 * @package rentalmgr
 * @copyright Copyright (c) 2013 Kevin Kucera
 * @user: kevin
 * @date: 9/1/13
 */

namespace Application\Dao;

use Application\ServiceLocator;
use Doctrine\ORM\EntityManager;
use Zend\ServiceManager\ServiceLocatorAwareInterface;
use Zend\ServiceManager\ServiceLocatorInterface;

class DoctrineFactory implements ServiceLocatorAwareInterface
{

    /**
     * @var EntityManager
     */
    static private $entityManager;

    /**
     * @var ServiceLocatorInterface
     */
    private $serviceLocator;

    /**
     * flush all entity changes
     */
    public function __destruct()
    {
        if(self::$entityManager){
            self::$entityManager->flush();
        }
    }

    /**
     * @return EntityManager
     */
    public function getEntityManager()
    {
        if(empty(self::$entityManager)){
            self::$entityManager = $this
                ->getServiceLocator()
                ->get('Doctrine\ORM\EntityManager');
        }
        return self::$entityManager;
    }

    /**
     * Set service locator
     *
     * @param ServiceLocatorInterface $serviceLocator
     */
    public function setServiceLocator(ServiceLocatorInterface $serviceLocator)
    {
        $this->serviceLocator = $serviceLocator;
    }

    /**
     * Get service locator
     *
     * @return ServiceLocatorInterface
     */
    public function getServiceLocator()
    {
        if(empty($this->serviceLocator)){
            $this->serviceLocator = new ServiceLocator();
        }
        return $this->serviceLocator;
    }
}
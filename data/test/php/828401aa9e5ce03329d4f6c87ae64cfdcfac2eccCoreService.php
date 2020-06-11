<?php
namespace Core\Service;

use Zend\ServiceManager\ServiceManager;
use Zend\ServiceManager\ServiceManagerAwareInterface;
use Zend\ServiceManager\Exception\ServiceNotFoundException;

/**
 * Classe de Apoio para os serviços
 *
 * @category Core
 * @package Service
 * @author  Daniel Chaves <daniel@danielchaves.com.br>
 * 
 */
 
abstract class CoreService implements ServiceManagerAwareInterface
{
	/**
     * @var ServiceManager
     */
    protected $serviceManager;
    
    protected $em;

    /**
     * @param ServiceManager $serviceManager
     */
    public function setServiceManager(ServiceManager $serviceManager)
    {
        $this->serviceManager = $serviceManager;
        //return $this;
    }

    /**
     * Retrieve serviceManager instance
     *
     * @return ServiceLocatorInterface
     */
    public function getServiceManager()
    {
        return $this->serviceManager;
    }

   
    /**
     * Retrieve Service
     * 
     * @return Service
     */
    protected function getService($service)
    {
        return $this->getServiceManager()->get($service);
    }
    
    public function setEntityManager(EntityManager $em)
    {
        $this->em = $em;
    }
    /**
     * Return a EntityManager
     *
     * @return EntityManager
     */
    protected function getEntityManager()
    {
        if ($this->em === null) {
            $this->em = $this->getService('Doctrine\ORM\EntityManager');
        }
    
        return $this->em;
    }
}
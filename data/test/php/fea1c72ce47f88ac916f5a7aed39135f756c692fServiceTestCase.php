<?php
namespace Core\Test;

use Zend\ServiceManager\ServiceManager;
use Zend\ServiceManager\ServiceManagerAwareInterface;
use Zend\ServiceManager\Exception\ServiceNotFoundException;

/**
 * Classe pai dos testes dos serviços
 * @category   Core
 * @package    Test
 * @author     Elton Minetto<eminetto@coderockr.com>
 */
abstract class ServiceTestCase extends TestCase implements ServiceManagerAwareInterface
{
    /**
     * @var ServiceManager
     */
    protected $serviceManager;

    /**
     * Cache 
     * @var Cache
     */
    protected $cache;

    /**
     * @param ServiceManager $serviceManager
     */
    public function setServiceManager(ServiceManager $serviceManager)
    {
        $this->serviceManager = $serviceManager;
    }

    /**
     * Retorna uma instância de serviceManager
     *
     * @return ServiceLocatorInterface
     */
    public function getServiceManager()
    {
        return $this->serviceManager;
    }
}

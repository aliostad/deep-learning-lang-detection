<?php
namespace Application\View\Helper;  

use Zend\View\Helper\AbstractHelper;
use Zend\ServiceManager\ServiceLocatorAwareInterface;
use Zend\ServiceManager\ServiceLocatorInterface;
/**
 * Description of CoreAbstractHelper
 *
 * @author alexander
 */
abstract class CoreAbstractHelper extends AbstractHelper implements ServiceLocatorAwareInterface {
    
    /**
     * Service locator
     *
     * @var ServiceLocatorInterface
     */
    private $serviceLocator;
    /**
     * Set the service locator.
     *
     * @param  ServiceLocatorInterface $serviceLocator
     * @return AbstractHelper
     */
    public function setServiceLocator(ServiceLocatorInterface $serviceLocator)
    {
        $this->serviceLocator = $serviceLocator;
        return $this;
    }
    /**
     * Get the service locator.
     *
     * @return ServiceLocatorInterface
     */
    public function getServiceLocator()
    {
        return $this->serviceLocator->getServiceLocator();
    }
}

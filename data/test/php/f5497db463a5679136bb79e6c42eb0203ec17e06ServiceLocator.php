<? 

namespace Back\Model\Data;

use Zend\ServiceManager\ServiceLocatorInterface;
use Back\Model\Data\ServiceLocatorFactory\ServiceLocatorFactory;

class ServiceLocator
{
    protected $service_manager;

    public function __construct()
    {
        $sm = ServiceLocatorFactory::getInstance();
        $this->setServiceLocator($sm);
    }

    public function setServiceLocator(ServiceLocatorInterface $serviceLocator)
    {
        $this->service_manager = $serviceLocator;
    }

    public function getServiceLocator()
    {
        return $this->service_manager;
    }
}

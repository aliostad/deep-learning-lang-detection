<?php

namespace PlaygroundSales\View\Helper;

use Zend\View\Helper\AbstractHelper;
use Zend\ServiceManager\ServiceLocatorAwareInterface;
use Zend\ServiceManager\ServiceLocatorInterface;
use PlaygroundSales\Service\Order as OrderService;

class Cart extends AbstractHelper implements ServiceLocatorAwareInterface
{

    /**
     * @var ServiceLocatorInterface
     */
    protected $serviceLocator;

    /**
     * @var OrderService
     */
    protected $orderService;
    
    
    /**
     * Return cart widget
     * @return string
     */
    public function __invoke() {
        
        return '';
    }

    public function setServiceLocator(ServiceLocatorInterface $serviceLocator)
    {
        $this->serviceLocator = $serviceLocator;
        return $this;
    }

    public function getServiceLocator()
    {
        return $this->serviceLocator;
    }
    

    /**
     *
     * @return \PlaygroundSales\Service\Order
     */
    public function getOrderService()
    {
        if (!$this->orderService) {
            $this->orderService = $this->getServiceLocator()->getServiceLocator()->get('playgroundsales_order_service');
        }
        return $this->orderService;
    }
    
    /**
     *
     * @param OrderService $productService
     * @return \PlaygroundSales\Service\Order
     */
    public function setOrderService(OrderService $orderService)
    {
        $this->orderService = $orderService;
        return $this;
    }
}
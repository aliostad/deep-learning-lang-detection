<?php
/**
 * @category  Shop99 library
 * @copyright http://shop99.vn
 * @license   http://shop99.vn/license
 */

namespace Order\View\Helper;

use Zend\View\Helper\AbstractHelper;
use Zend\ServiceManager\ServiceLocatorInterface;

class Cart extends AbstractHelper
{

    /**
     * @var ServiceLocatorInterface
     */
    protected $serviceLocator;

    /**
     * @var \Order\Service\Cart
     */
    protected $serviceCart;

    /**
     * @param \Zend\ServiceManager\ServiceLocatorInterface $serviceLocator
     */
    public function setServiceLocator($serviceLocator)
    {
        $this->serviceLocator = $serviceLocator;
    }

    /**
     * @return \Zend\ServiceManager\ServiceLocatorInterface
     */
    public function getServiceLocator()
    {
        return $this->serviceLocator;
    }

    /**
     * @param \Zend\ServiceManager\ServiceLocatorInterface $serviceLocator
     */
    public function __construct($serviceLocator)
    {
        $this->setServiceLocator($serviceLocator);
    }

    /**
     * @param \Order\Service\Cart $serviceCart
     */
    public function setServiceCart($serviceCart)
    {
        $this->serviceCart = $serviceCart;
    }

    /**
     * @return \Order\Service\Cart
     */
    public function getServiceCart()
    {
        if (!$this->serviceCart) {
            $this->serviceCart = $this->getServiceLocator()->get('Order\Service\Cart');
        }
        return $this->serviceCart;
    }

    public function __invoke()
    {
        return $this;
    }

}
<?php

class Autorele_Monitor_Helper_Data extends Mage_Core_Helper_Abstract
{

    protected $_customerMonitor = null;


    public function getCustomerMonitor()
    {
        if (is_null($this->_customerMonitor)) {
            $customerId      = (int)Mage::getSingleton('customer/session')->getCustomer()->getId();
            $customerIp      = Mage::helper('core/http')->getRemoteAddr();
            $customerMonitor = Mage::getModel('autorele_monitor/monitor')->getCustomerMonitor($customerId, $customerIp);
            if (!$customerMonitor->getId() && $customerId) {
                $customerMonitor->setCustomerId($customerId);
            }
            $customerMonitor->setCustomerIp($customerIp);
            $this->_customerMonitor = $customerMonitor;
        }
        return $this->_customerMonitor;
    }

}

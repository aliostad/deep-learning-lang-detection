<?php
/**
 * Copyright © 2013-2017 Magento, Inc. All rights reserved.
 * See COPYING.txt for license details.
 */
namespace Magento\CustomerSegment\Observer;

use Magento\Framework\Event\ObserverInterface;

class ProcessCustomerEventObserver implements ObserverInterface
{
    /**
     * @var \Magento\CustomerSegment\Model\Customer
     */
    protected $_customer;

    /**
     * @param \Magento\CustomerSegment\Model\Customer $customer
     */
    public function __construct(
        \Magento\CustomerSegment\Model\Customer $customer
    ) {
        $this->_customer = $customer;
    }

    /**
     * Process customer related data changing. Method can process just events with customer object
     *
     * @param \Magento\Framework\Event\Observer $observer
     * @return void
     */
    public function execute(\Magento\Framework\Event\Observer $observer)
    {
        $customer = $observer->getEvent()->getCustomer();
        $dataObject = $observer->getEvent()->getDataObject();

        $customerId = false;
        if ($customer) {
            $customerId = $customer->getId();
        }
        if (!$customerId && $dataObject) {
            $customerId = $dataObject->getCustomerId();
        }
        if ($customerId) {
            $this->_customer->processCustomerEvent($observer->getEvent()->getName(), $customerId);
        }
    }
}

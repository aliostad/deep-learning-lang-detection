<?php

namespace Zoop\Payment\Gateway\Paypal\Common\Service;

use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;

class TransactionSearchFactory implements FactoryInterface
{
    /**
     *
     * @param \Zend\ServiceManager\ServiceLocatorInterface $serviceLocator
     * @return \Zoop\Payment\Service\Paypal\TransactionSearch
     */
    public function createService(ServiceLocatorInterface $serviceLocator)
    {
        $merchantService = $serviceLocator->get('zoop.payment.paypal.merchant');
        
        $transactionSearchService = new TransactionSearch();
        $transactionSearchService->setMerchantService($merchantService);

        return $transactionSearchService;
    }
}
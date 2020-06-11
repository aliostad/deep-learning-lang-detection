<?php

namespace Tactics\InvoiceBundle\Tools;

use Tactics\InvoiceBundle\Model\ObjectManager as CustomerInfoMgr;

class CustomerFactory implements CustomerFactoryInterface
{
    private $customerClass;
    private $customerInfoMgr;
    
    /**
     * 
     * @param string $customerClass
     * @param CustomerInfoMgr $customerInfoMgr
     */
    public function __construct($customerClass, CustomerInfoMgr $customerInfoMgr)
    {
        $this->customerClass = $customerClass;
        $this->customerInfoMgr = $customerInfoMgr;
    }
   
    /**
     * Geeft de correcte customer terug op basis van de ingestelde accounting_software
     * 
     * @param mixed $appCustomerOrInvoice The application customer object
     * @return mixed an invoice customer
     */
    public function getCustomer($appCustomerOrInvoice)
    {
        if (get_class($appCustomerOrInvoice) === 'Tactics\InvoiceBundle\Model\Invoice')
        {
            $appCustomer = $appCustomerOrInvoice->getCustomer();
        }
        else
        {
            $appCustomer = $appCustomerOrInvoice;
        }
        
        $customerClass = $this->customerClass;        
        return new $customerClass($appCustomer, $this->customerInfoMgr);
    }
}


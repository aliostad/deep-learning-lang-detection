<?php

namespace Tactics\InvoiceBundle\Propel;

class SchemeCustomerInfoTransformer extends Transformer
{
    /**
     * Geeft PropelSchemeCustomerInfo terug op basis van $schemeCustomerInfo
     * 
     * @param Tactics\InvoiceBundle\Model\SchemeCustomerInfo $schemeCustomerInfo
     * @return \PropelSchemeCustomerInfo $propelInfo
     */
    public function toOrm($schemeCustomerInfo)
    {
        $propelInfo = parent::toOrm($schemeCustomerInfo);
        
        if ($customer = $schemeCustomerInfo->getCustomer())
        {
            $propelInfo->setCustomerClass(get_class($customer));
            $propelInfo->setCustomerId($customer->getId());
        }

        return $propelInfo;
    }
    
    /**
     * Geeft domain account terug op basis van $propelSchemeCustomerInfo
     * 
     * @param \PropelSchemeCustomerInfo $propelSchemeCustomerInfo
     * @return \Tactics\InvoiceBundle\Model\SchemeCustomerInfo
     */
    public function fromOrm($propelSchemeCustomerInfo)
    {
        if (!$propelSchemeCustomerInfo)
        {
            return null;
        }
        
        $info = parent::fromOrm($propelSchemeCustomerInfo);
        
        $customer = Helper::classAndIdToObject($propelSchemeCustomerInfo->toArray(), 'Customer');
        if ($customer)
        {
          $info->setCustomer($customer);
        }
        
        return $info;
    }      
}


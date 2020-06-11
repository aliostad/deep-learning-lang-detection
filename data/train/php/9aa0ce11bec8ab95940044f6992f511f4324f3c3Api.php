<?php

class Gemgento_Customer_Model_Customer_Api extends Mage_Customer_Model_Customer_Api
{

    /**
     * Update customer data
     *
     * @param int $customerId
     * @param array $customerData
     * @return boolean
     */
    public function update($customerId, $customerData)
    {
        $customerData = $this->_prepareData($customerData);

        $customer = Mage::getModel('customer/customer')->load($customerId);

        if (!$customer->getId()) {
            $this->_fault('not_exists');
        }

        foreach ($this->getAllowedAttributes($customer) as $attributeCode=>$attribute) {
            print($attributeCode . '\n');
            if (isset($customerData[$attributeCode])) {
                $customer->setData($attributeCode, $customerData[$attributeCode]);
            }
        }

        if (isset($customerData['password']) && $customerData['password'] !== '') {
            $customer->setPassword($customerData['password']);
        }

        $customer->save();
        return true;
    }

} // Class Mage_Customer_Model_Customer_Api End

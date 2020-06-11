<?php

class TBT_Milestone_Block_Manage_Grid_Renderer_Customer extends Mage_Adminhtml_Block_Widget_Grid_Column_Renderer_Abstract
{
    /**
     * Array of loaded customers
     *
     * @var array
     **/
    protected $_customers = array();

    public function render(Varien_Object $row)
    {
        $element    = '';
        $customerId = $row->getCustomerId();

        if ($customer = $this->_getCustomer($customerId)) {
            $customerName = $customer->getName();
            $url          = $this->getUrl('adminhtml/customer/edit/', array ('id' => $customerId));
            $element      = "<a href='{$url}'>{$customerName}</a>";
        }

        return $element;
    }

    protected function _getCustomer($customerId)
    {
        if (!isset($this->_customers[$customerId])) {
            $customer = Mage::getModel('customer/customer')->load($customerId);
            if ($customer->getId()) {
                $this->_customers[$customerId] = $customer;
            }
        }

        return $this->_customers[$customerId];
    }
}

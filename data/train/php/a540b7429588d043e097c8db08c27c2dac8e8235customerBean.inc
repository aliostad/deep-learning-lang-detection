<?php

/**
 * Description of customerBean
 *
 * @author liukai
 */
class customerBean {

    private static $customerArray = array();

    public function __construct() {
        
        self::$customerArray['customer_id'] = Tools::getValue('customerCode', '');
        self::$customerArray['customer_name'] = Tools::getValue('customerName', '');
        self::$customerArray['customer_addr'] = Tools::getValue('customerAddr', '');
        self::$customerArray['customer_postal_code'] = Tools::getValue('PostalCode', '');
        self::$customerArray['customer_group'] = Tools::getValue('customergroup', '');
        self::$customerArray['customer_grade'] = Tools::getValue('customergrade', '');
        self::$customerArray['customer_country'] = Tools::getValue('customercountry', '');
        self::$customerArray['customer_province'] = Tools::getValue('customerprovince', '');
        self::$customerArray['customer_from'] = Tools::getValue('customerfrom', '');
        self::$customerArray['customer_website'] = Tools::getValue('customerwebsite', '');
        self::$customerArray['customer_attention'] = Tools::getValue('customerattention', '');
        self::$customerArray['customer_remarks'] = Tools::getValue('customerremarks', '');
    }
    
    public function getCustomerArray() {
        return self::$customerArray;
    }
    
    public static function setCustomerData($param) {
        $customerArray  = array();
        $customerArray['customer_id'] = isset($param['customer_id'])?$param['customer_id']:'';
        $customerArray['customer_name'] = isset($param['customer_name'])?$param['customer_name']:'';
        $customerArray['customer_addr'] = isset($param['customer_addr'])?$param['customer_addr']:'';
        $customerArray['customer_postal_code'] = isset($param['customer_postal_code'])?$param['customer_postal_code']:'';
        $customerArray['customer_group'] = isset($param['customer_group'])?$param['customer_group']:'';
        $customerArray['customer_grade'] = isset($param['customer_grade'])?$param['customer_grade']:'';
        $customerArray['customer_country'] = isset($param['customer_country'])?$param['customer_country']:'';
        $customerArray['customer_province'] = isset($param['customer_province'])?$param['customer_province']:'';
        $customerArray['customer_from'] = isset($param['customer_from'])?$param['customer_from']:'';
        $customerArray['customer_whohave'] = isset($param['customer_whohave'])?$param['customer_whohave']:'';
        $customerArray['customer_website'] = isset($param['customer_website'])?$param['customer_website']:'';
        $customerArray['customer_attention'] = isset($param['customer_attention'])?$param['customer_attention']:'';
        $customerArray['customer_remarks'] = isset($param['customer_remarks'])?$param['customer_remarks']:'';
        $customerArray['contact_name'] = isset($param['contact_name'])?$param['contact_name']:'';
        $customerArray['contact_email'] = isset($param['contact_email'])?$param['contact_email']:'';
        $customerArray['contact_tel'] = isset($param['contact_tel'])?$param['contact_tel']:'';
        $customerArray['contact_fax'] = isset($param['customer_remarks'])?$param['contact_fax']:'';
        $customerArray['contact_msn'] = isset($param['contact_msn'])?$param['contact_msn']:'';
        $customerArray['contact_skype'] = isset($param['contact_skype'])?$param['contact_skype']:'';
        $customerArray['contact_other'] = isset($param['contact_other'])?$param['contact_other']:'';
        $customerArray['contact_phone'] = isset($param['contact_phone'])?$param['contact_phone']:'';
        $customerArray['customer_first_contacter'] = isset($param['customer_first_contacter'])?$param['customer_first_contacter']:'';
        return $customerArray;
    }
}

?>
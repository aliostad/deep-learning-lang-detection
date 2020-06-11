<?php
class Cminds_Supplierfrontendproductuploader_Model_Config_Source_Presentation_Visibility {
    const DONT_SHOW = 0;
    const SHOW_CUSTOM = 1;
    const SHOW_DEFAULT = 2;

    public function toOptionArray() {
        $options = array(
            array('value' => self::DONT_SHOW, 'label' => Mage::helper('supplierfrontendproductuploader')->__("Don't show")),
            array('value' => self::SHOW_CUSTOM, 'label' => Mage::helper('supplierfrontendproductuploader')->__('Show Custom')),
            array('value' => self::SHOW_DEFAULT, 'label' => Mage::helper('supplierfrontendproductuploader')->__('Show Default'))
        );
        return $options;
    }
}

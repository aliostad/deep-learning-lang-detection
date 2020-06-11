<?php
if( !defined( '_VALID_MOS' ) && !defined( '_JEXEC' ) ) die( 'Direct Access to '.basename(__FILE__).' is not allowed.' ); 

define ('PAYPAL_API_API_USERNAME', '');
define ('PAYPAL_API_API_PASSWORD', '');
define ('PAYPAL_API_API_SIGNATURE', '');
define ('PAYPAL_API_PAYMENTTYPE', 'Sale');
define ('PAYPAL_API_IMAGEURL', '');
define ('PAYPAL_API_CART_BUTTON_ON', '1');
define ('PAYPAL_API_DIRECT_PAYMENT_ON', '0');
define ('PAYPAL_API_VERIFIED_ONLY', '1');
define ('PAYPAL_API_VERIFIED_STATUS', 'C');
define ('PAYPAL_API_PENDING_STATUS', 'P');
define ('PAYPAL_API_INVALID_STATUS', 'X');
define ('PAYPAL_API_CHECK_CARD_CODE', 'YES');
define ('PAYPAL_API_CERTIFICATE', '');
define ('PAYPAL_API_USE_SHIPPING', '1');
define ('PAYPAL_API_DEBUG', '0');
?>
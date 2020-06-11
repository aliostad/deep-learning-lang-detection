<?php

// load config
require_once(JPATH_ADMINISTRATOR . '/components/com_zoo/config.php');

return 
'{"fields": {

	"show_items":{
		"type":"radio",
		"label":"MOD_ZOOCART_PARAMS_SHOW_ITEMS",
		"default":"1"
	},
	"show_cart_link":{
		"type":"radio",
		"label":"MOD_ZOOCART_PARAMS_SHOW_CART_LINK",
		"default":"1"
	},
	"show_addresses_link":{
		"type":"radio",
		"label":"MOD_ZOOCART_PARAMS_SHOW_ADDRESSES_LINK",
		"default":"1"
	},
	"show_orders_link":{
		"type":"radio",
		"label":"MOD_ZOOCART_PARAMS_SHOW_ORDERS_LINK",
		"default":"1"
	}

}}';
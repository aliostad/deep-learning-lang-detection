<?php 
//link the controller to the nav link

$route[FUEL_ROUTE.'customer_outward'] = FUEL_FOLDER.'/module';
$route[FUEL_ROUTE.'customer_outward/(.*)'] = FUEL_FOLDER.'/module/$1';
$route[FUEL_ROUTE.'customer_outward'] = 'customer_outward';
$route[FUEL_ROUTE.'customer_outward/dashboard'] = 'customer_outward/dashboard';
$route[FUEL_ROUTE.'customer_outward/cutting_instruction'] = 'customer_outward/cutting_instruction';
$route[FUEL_ROUTE.'customer_outward/list_coil'] = 'customer_outward/list_coil';
$route[FUEL_ROUTE.'customer_outward/list_party'] = 'customer_outward/list_party';
$route[FUEL_ROUTE.'customer_outward/listChilds'] = 'customer_outward/listChilds';
$route[FUEL_ROUTE.'customer_outward/delete_coil'] = 'customer_outward/delete_coil';
$route[FUEL_ROUTE.'customer_outward/print_partywise'] = 'customer_outward/print_partywise';
//$route[FUEL_ROUTE.'customer_outward/list_child_coil/(.*)'] = 'customer_outward/list_child_coil/$1';
$route[FUEL_ROUTE.'customer_outward/totalb_weight'] = 'customer_outward/totalb_weight';
$route[FUEL_ROUTE.'customer_outward/totalweight_check'] = 'customer_outward/totalweight_check';

//link the controller to the nav link

$route[FUEL_ROUTE.'customer_outward'] = FUEL_FOLDER.'/module';
$route[FUEL_ROUTE.'customer_outward/(.*)'] = FUEL_FOLDER.'/module/$1';

$route[FUEL_ROUTE.'customer_outward'] = 'customer_outward';
$route[FUEL_ROUTE.'customer_outward/dashboard'] = 'customer_outward/dashboard';
$route[FUEL_ROUTE.'customer_outward/list_coil'] = 'customer_outward/list_coil';
$route[FUEL_ROUTE.'customer_outward/list_party'] = 'customer_outward/list_party';
$route[FUEL_ROUTE.'customer_outward/print_partywise'] = 'customer_outward/print_partywise';
$route[FUEL_ROUTE.'customer_outward/totalweight_check'] = 'customer_outward/totalweight_check';
$route[FUEL_ROUTE.'customer_outward/billing_pdf'] = 'customer_outward/billing_pdf';
$route[FUEL_ROUTE.'customer_outward/export_party'] = 'customer_outward/export_party';



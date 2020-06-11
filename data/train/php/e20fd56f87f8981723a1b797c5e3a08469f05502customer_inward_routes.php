<?php 
//link the controller to the nav link

$route[FUEL_ROUTE.'customer_inward'] = FUEL_FOLDER.'/module';
$route[FUEL_ROUTE.'customer_inward/(.*)'] = FUEL_FOLDER.'/module/$1';
$route[FUEL_ROUTE.'customer_inward'] = 'customer_inward';
$route[FUEL_ROUTE.'customer_inward/dashboard'] = 'customer_inward/dashboard';
$route[FUEL_ROUTE.'customer_inward/cutting_instruction'] = 'customer_inward/cutting_instruction';
$route[FUEL_ROUTE.'customer_inward/list_coil'] = 'customer_inward/list_coil';
$route[FUEL_ROUTE.'customer_inward/list_party'] = 'customer_inward/list_party';
$route[FUEL_ROUTE.'customer_inward/listChilds'] = 'customer_inward/listChilds';
$route[FUEL_ROUTE.'customer_inward/delete_coil'] = 'customer_inward/delete_coil';
$route[FUEL_ROUTE.'customer_inward/print_partywise'] = 'customer_inward/print_partywise';
//$route[FUEL_ROUTE.'customer_inward/list_child_coil/(.*)'] = 'customer_inward/list_child_coil/$1';
$route[FUEL_ROUTE.'customer_inward/totalb_weight'] = 'customer_inward/totalb_weight';
$route[FUEL_ROUTE.'customer_inward/totalweight_check'] = 'customer_inward/totalweight_check';

//link the controller to the nav link

$route[FUEL_ROUTE.'customer_inward'] = FUEL_FOLDER.'/module';
$route[FUEL_ROUTE.'customer_inward/(.*)'] = FUEL_FOLDER.'/module/$1';

$route[FUEL_ROUTE.'customer_inward'] = 'customer_inward';
$route[FUEL_ROUTE.'customer_inward/dashboard'] = 'customer_inward/dashboard';
$route[FUEL_ROUTE.'customer_inward/list_coil'] = 'customer_inward/list_coil';
$route[FUEL_ROUTE.'customer_inward/list_party'] = 'customer_inward/list_party';
$route[FUEL_ROUTE.'customer_inward/print_partywise'] = 'customer_inward/print_partywise';
$route[FUEL_ROUTE.'customer_inward/totalweight_check'] = 'customer_inward/totalweight_check';
$route[FUEL_ROUTE.'customer_inward/billing_pdf'] = 'customer_inward/billing_pdf';
$route[FUEL_ROUTE.'customer_inward/export_party'] = 'customer_inward/export_party';

<?php 
//link the controller to the nav link

$route[FUEL_ROUTE.'customer_billing'] = FUEL_FOLDER.'/module';
$route[FUEL_ROUTE.'customer_billing/(.*)'] = FUEL_FOLDER.'/module/$1';
$route[FUEL_ROUTE.'customer_billing'] = 'customer_billing';
$route[FUEL_ROUTE.'customer_billing/dashboard'] = 'customer_billing/dashboard';
$route[FUEL_ROUTE.'customer_billing/cutting_instruction'] = 'customer_billing/cutting_instruction';
$route[FUEL_ROUTE.'customer_billing/list_coil'] = 'customer_billing/list_coil';
$route[FUEL_ROUTE.'customer_billing/list_party'] = 'customer_billing/list_party';
$route[FUEL_ROUTE.'customer_billing/listChilds'] = 'customer_billing/listChilds';
$route[FUEL_ROUTE.'customer_billing/delete_coil'] = 'customer_billing/delete_coil';
$route[FUEL_ROUTE.'customer_billing/print_partywise'] = 'customer_billing/print_partywise';
$route[FUEL_ROUTE.'customer_billing/totalbasic_check'] = 'customer_billing/totalbasic_check';
$route[FUEL_ROUTE.'customer_billing/totalb_weight'] = 'customer_billing/totalb_weight';
$route[FUEL_ROUTE.'customer_billing/totalweight_check'] = 'customer_billing/totalweight_check';
$route[FUEL_ROUTE.'customer_billing/totaltax_check'] = 'customer_billing/totaltax_check';  
$route[FUEL_ROUTE.'customer_billing/totalbill_check'] = 'customer_billing/totalbill_check'; 

$route[FUEL_ROUTE.'customer_billing/partytotaltax_check'] = 'customer_billing/partytotaltax_check';  
$route[FUEL_ROUTE.'customer_billing/partytotalbasic_check'] = 'customer_billing/partytotalbasic_check'; 
//link the controller to the nav link

$route[FUEL_ROUTE.'customer_billing'] = FUEL_FOLDER.'/module';
$route[FUEL_ROUTE.'customer_billing/(.*)'] = FUEL_FOLDER.'/module/$1';

$route[FUEL_ROUTE.'customer_billing'] = 'customer_billing';
$route[FUEL_ROUTE.'customer_billing/dashboard'] = 'customer_billing/dashboard';
$route[FUEL_ROUTE.'customer_billing/list_coil'] = 'customer_billing/list_coil';
$route[FUEL_ROUTE.'customer_billing/list_party'] = 'customer_billing/list_party';
$route[FUEL_ROUTE.'customer_billing/print_partywise'] = 'customer_billing/print_partywise';
$route[FUEL_ROUTE.'customer_billing/totalweight_check'] = 'customer_billing/totalweight_check';
$route[FUEL_ROUTE.'customer_billing/billing_pdf'] = 'customer_billing/billing_pdf';
$route[FUEL_ROUTE.'customer_billing/list_individualparty'] = 'customer_billing/list_individualparty';
$route[FUEL_ROUTE.'customer_billing/partytotalbill_check'] = 'customer_billing/partytotalbill_check';

$route[FUEL_ROUTE.'customer_billing/partytotalweight_check'] = 'customer_billing/partytotalweight_check';

$route[FUEL_ROUTE.'customer_billing/export_party'] = 'customer_billing/export_party';

<?php

require realpath(__DIR__ . '/../vendor/autoload.php');

use PHPECOSRV\Config\Reader;
use PHPECOSRV\Components\Customer\SoapCustomer;

$reader = new Reader(realpath(__DIR__ . '/../config.ini'));
$customer = new SoapCustomer($reader);

$customer->Name = 'CompuGlobalHyperMegaNet';
$customer->Address = '742 Evergreen Terrace';
$customer->City = 'Sprintfield';
$customer->PostalCode = 2300;
$customer->Email = 'chunkylover53@aol.com';
$customer->Country = 'Denmark';
$customer->CINumber = '88888888';
$customer->TelephoneAndFaxNumber = '12345678';

$customer = $customer->createCustomer();

echo $customer->Name;
?>

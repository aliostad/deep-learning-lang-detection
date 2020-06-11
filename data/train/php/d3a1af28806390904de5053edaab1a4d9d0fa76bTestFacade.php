<?php
require_once 'PurchasingFacade.php';
require_once 'Debuggers.php';

use de\phpdesignpatterns\util\debug\DebuggerEcho;
use de\phpdesignpatterns\rental\RentalCompany;

use de\phpdesignpatterns\manufacturers\CarManufacturer;
use de\phpdesignpatterns\manufacturers\ConvertibleManufacturer;

use de\phpdesignpatterns\facades\PurchasingFacade;

$company = new RentalCompany(new DebuggerEcho());
$bmwManufacturer = new CarManufacturer('BMW');
$peugeotManufacturer = new ConvertibleManufacturer('Peugeot');

$facade = new PurchasingFacade($company);
$facade->addManufacturer('bmw', $bmwManufacturer);
$facade->addManufacturer('peugeot', $peugeotManufacturer);

$facade->purchase('bmw', 'blau');
$facade->purchase('peugeot', 'rot');

print_r($company);
?>
<?php

// Ejemplo tomado de http://www.newthinktank.com/2012/09/facade-design-pattern-tutorial/

require_once __DIR__ . '/../bootstrap.php';

use Structural\Facade\BankAccount\BankAccountFacade;
use Util\Util;

$newAcctNum = '12345678';
$newSecCode = 1234;

$bankAccountFacade = new BankAccountFacade($newAcctNum, $newSecCode);

echo 'Cash in Account: ' . $bankAccountFacade->getCashInAccount() . PHP_EOL;

$bankAccountFacade->depositCash(100);
$bankAccountFacade->withdrawCash(500);

echo 'Cash in Account: ' . $bankAccountFacade->getCashInAccount() . PHP_EOL;

$bankAccountFacade->withdrawCash(1000);

Util::showImage(__FILE__);
Util::showCode(__FILE__);
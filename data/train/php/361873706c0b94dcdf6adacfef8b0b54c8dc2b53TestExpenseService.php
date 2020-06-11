<?php

class TestExpenseService extends UnitTestCase
{
    function testGetExpenses()
    {
        $dbService = za()->getService('DbService');
        /* @var $dbService DbService */
        $dbService->delete('expense');
        $dbService->delete('client');

        $clientService = za()->getService('ClientService');
        /* @var $clientService ClientService */

        $expenseService = za()->getService('ExpenseService');
        /* @var $clientService ExpenseService */
        
        $params['title'] = 'Client';
        $client = $clientService->saveClient($params);
        
        $expense1 = array('description');
    }
}
?>
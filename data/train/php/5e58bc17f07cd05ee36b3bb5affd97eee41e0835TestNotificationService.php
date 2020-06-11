<?php

class TestNotificationService extends UnitTestCase 
{
    public function testAddNote()
    {
        $dbService = za()->getService('DbService');
        /* @var $dbService DbService */
        $dbService->delete('client');
        $dbService->delete('note');
        
        $clientService = za()->getService('ClientService');
        /* @var $clientService ClientService */
        $notificationService = za()->getService('NotificationService');
        /* @var $notificationService NotificationService */
        
        $params['title'] = 'Client';
        
        $client = $clientService->saveClient($params);
        
        // Add a note to that client
        $notificationService->addNoteTo($client, "This is a note", "Note Title");
        $notes = $notificationService->getNotesFor($client);
        
        $this->assertEqual(1, count($notes));
        $this->assertEqual('This is a note', $notes[0]->note);
        $this->assertEqual('Note Title', $notes[0]->title);
    }
}
?>
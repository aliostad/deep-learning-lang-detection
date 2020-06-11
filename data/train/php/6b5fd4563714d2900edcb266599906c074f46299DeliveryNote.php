<?php

App::uses('DocumentType', 'Model');
App::uses('DeliveryDataCopyStrategy', 'Lib/DataCopyStrategy');
App::uses('DeliveryNoteFromOrderDataCopyStrategy', 'Lib/DataCopyStrategy');

class DeliveryNote extends DocumentType {

    public $belongsTo = array(
        'Document',
        'DeliveryAddress'
    );    
    
    protected function getCopyStrategy($params) {
        return new DeliveryDataCopyStrategy($params);
    }

    protected function getCopyFromOrderStrategy($params) {
        return new DeliveryNoteFromOrderDataCopyStrategy($params);
    }

}

<?php

App::uses('CustomerAppModel', 'Customer.Model');

class Customer extends CustomerAppModel {

    public $name = 'Customer';
    public $actsAs = array(
        'Cached' => array(
            'prefix' => array(
                'service_',
            ),
        ),
    );
    public $_displayFields = array(
        'id',
        'images',
        'title',
        'created',
        'updated'
    );

    function getData($id = null) {
        $options = array(
            'conditions' => array('Customer.status' => 1,'Customer.parent > ' => 0),
            'fields' => array('Customer.id', 'Customer.path', 'Customer.parent', 'Customer.title', 'Customer.excerpt', 'Customer.updated', 'Customer.images', 'Customer.description')
        );
        $data = $this->find('all', $options);
        return $data;
    }

}
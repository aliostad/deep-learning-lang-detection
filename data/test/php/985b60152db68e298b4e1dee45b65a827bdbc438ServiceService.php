<?php
App::uses('AppModel', 'Model');
/**
 * ServiceService Model
 *
 */
class ServiceService extends AppModel {

/**
 * Display field
 *
 * @var string
 */
	public $displayField = 'name';
	
/*	public $belongsTo = array(
		'ServiceDevice' => array(
			'className' => 'ServiceDevice',
			'foreignKey' => 'service_device_id',
			'conditions' => '',
			'fields' => '',
			'order' => ''
		),
		);*/
	
	public $hasMany = array(
		'ServiceDevicesService' => array(
			'className' => 'ServiceDevicesService',
			'foreignKey' => 'service_service_id',
			'conditions' => '',
			'fields' => '',
			'order' => ''
		),
		);
		
		

}

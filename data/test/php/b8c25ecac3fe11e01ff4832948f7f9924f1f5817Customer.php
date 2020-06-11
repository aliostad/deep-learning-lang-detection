<?php namespace Invoice\customers;

use Invoice\eventing\EventGenerator;
use File;

class Customer extends \Eloquent {

	use EventGenerator;

	protected $fillable = [
		'customerName',
		'customerAddressBuilding',
		'customerAddressStreet',
		'customerAddressCity',
		'customerAddressCounty',
		'customerAddressPostCode',
		'customerPhone'
	 ];

	// Add your validation rules here
	public static $rules = array(
		'customerName' 				=> 	'required',
		'customerAddressBuilding'	=> 	'required',
		'customerAddressStreet'		=> 	'required',
		'customerAddressCity'		=> 	'required',
		'customerAddressPostCode'	=>	'required',
		'customerPhone'				=>	'required'

	);

	public function invoices() {
		return $this->belongsToMany('Invoice');
	}


	public static function storeCustomer( $input ){

		// Break out inputs
		$customerName 				=	$input['customerName'];
		$customerAddressBuilding	=	$input['customerAddressBuilding'];
		$customerAddressStreet		=	$input['customerAddressStreet'];
		$customerAddressCity		=	$input['customerAddressCity'];
		$customerAddressCounty		=	$input['customerAddressCounty'];
		$customerAddressPostCode	=	$input['customerAddressPostCode'];
		$customerPhone 				=	$input['customerPhone'];

		// store invoice details in DB through Eloquent model
		$customer = static::create( compact(
			'customerName',
			'customerAddressBuilding',
			'customerAddressStreet',
			'customerAddressCity',
			'customerAddressCounty',
			'customerAddressPostCode',
			'customerPhone'
		));

		// Fire a event
		$customer->raise( new CustomerWasStored( $customer ));

		return $customer;
	}

	public function deleteCustomer(){

		// delete customer details from DB
		$this->delete();

		//Fire a event
		$this->raise ( new CustomerWasDeleted( $this ) );

		return $this;
	}

	public function updateCustomer( $id, $input ){

		$customer = $this->findOrFail( $id );

		// Break out inputs
		$customer->customerName 			= $input['customerName'];
		$customer->customerAddressBuilding 	= $input['customerAddressBuilding'];
		$customer->customerAddressStreet 	= $input['customerAddressStreet'];
		$customer->customerAddressCity	 	= $input['customerAddressCity'];
		$customer->customerAddressCounty 	= $input['customerAddressCounty'];
		$customer->customerAddressPostCode 	= $input['customerAddressPostCode'];
		$customer->customerPhone 			= $input['customerPhone'];
		$customer->update();

		$customer->raise( new CustomerWasUpdated( $customer ) );

		return $customer;
	}

}

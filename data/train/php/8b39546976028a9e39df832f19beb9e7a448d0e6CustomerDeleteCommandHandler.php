<?php namespace Invoice\customers;

use Invoice\Commanding\CommandHandler;
use Invoice\eventing\EventDispatcher;
// use Log;

class CustomerDeleteCommandHandler implements CommandHandler {

	protected $customer;
	protected $dispatcher;

	function __construct( Customer $customer, EventDispatcher $dispatcher)
	{
		$this->customer = $customer;
		$this->dispatcher = $dispatcher;
		
	}

	public function handle( $command )
	{
		
		$customer = $this->customer->findOrFail ($command->id);

		$customer->deleteCustomer();

		$this->dispatcher->dispatch ( $customer->releaseEvents() );
	}

}
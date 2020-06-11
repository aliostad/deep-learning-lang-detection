<?php namespace BCD\Clients\Registration;

use Laracasts\Commander\CommandHandler;
use BCD\Clients\ClientRepository;

class RemoveClientCommandHandler implements CommandHandler {
	/**
	* @var ClientRepository $clientRepository
	*/
	protected $clientRepository;


	/**
	* Constructor
	*
	* @var ClientRepository $clientRepository
	*/
	function __construct(ClientRepository $clientRepository) {
		$this->clientRepository = $clientRepository;
	}

	/**
	* Handles the command.
	*
	* @param RemoveClientCommand $command
	* @return Client
	*/
	public function handle($command) {
		$clientRemove = $this->clientRepository->remove($command->client_id);

		return $clientRemove;
	}
}
<?php namespace BCD\Clients\Registration;

use Laracasts\Commander\CommandHandler;
use BCD\Clients\ClientRepository;

class RestoreClientCommandHandler implements CommandHandler {
	
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
	* @param RestoreClientCommand $command
	* @return Client
	*/
	public function handle($command) {
		$clientRestore = $this->clientRepository->restore($command->client_id);

		return $clientRestore;
	}
}
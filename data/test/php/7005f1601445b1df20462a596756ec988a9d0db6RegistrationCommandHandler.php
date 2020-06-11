<?php namespace BMW\Registrations;

use Laracasts\Commander\CommandHandler;
use BMW\Registrations\Registration;
use BMW\Registrations\RegistrationRepository;

class RegistrationCommandHandler implements CommandHandler {

	/**
	* @var RegistrationRepository $registrationRepository
	*/
	protected $registrationRepository;
	

	/**
	* Constructor
	*
	* @param RegistrationRepository $registrationRepository
	*/
	function __construct(RegistrationRepository $registrationRepository) {
		$this->registrationRepository = $registrationRepository;
	}


	/**
	*
	* Handle the command
	*
	* @param IndividualRegistrationCommand $command
	* @return mixed
	*/
	public function handle($command) {
		// Create Registration Object
		$registration = Registration::add(
			$command->registration_id
		);

		$registration = $this->registrationRepository->save($registration);
		
		return $registration;
	}
}
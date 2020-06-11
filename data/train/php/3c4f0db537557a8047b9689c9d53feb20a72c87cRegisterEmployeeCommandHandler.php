<?php namespace BCD\Employees\Registration;

use Laracasts\Commander\CommandHandler;
use BCD\Employees\Account;
use BCD\Employees\Employee;
use BCD\Employees\AccountRepository;
use BCD\Employees\EmployeeRepository;

class RegisterEmployeeCommandHandler implements CommandHandler {
	
	/**
	* @var AccountRepository $accountRepository
	*/
	protected $accountRepository;

	/**
	* @var EmployeeRepository $employeeRepository
	*/
	protected $employeeRepository;


	/**
	* @param AccountRepository $accountRepository
	* @param EmployeeRepository $employeeRepository
	*/
	function __construct(AccountRepository $accountRepository, EmployeeRepository $employeeRepository) {
		$this->accountRepository = $accountRepository;
		$this->employeeRepository = $employeeRepository;
	}


	/**
	*
	* Handle the command
	*
	* @param RegisterEmployeeCommand $command
	* @return mixed
	*/
	public function handle($command) {
		
		$account = Account::addAccount(
			$command->username,
			$command->password
		);

		$employee = Employee::register(
			$command->username, $command->first_name, $command->middle_name, $command->last_name,
			$command->birthdate, $command->address, $command->email, $command->mobile,
			$command->department_id
		);
		
		$this->accountRepository->save($account);

		$this->employeeRepository->save($employee);

		return $employee;
	}
}
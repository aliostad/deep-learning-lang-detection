<?php namespace BCD\Departments\Registration;

use Laracasts\Commander\CommandHandler;
use BCD\Departments\DepartmentRepository;
use BCD\Employees\EmployeeRepository;

class RestoreDepartmentCommandHandler implements CommandHandler {
	/**
	* @var DepartmentRepository
	*/
	protected $departmentRepository;

	/**
	* @var EmployeeRepository
	*/
	protected $employeeRepository;

	/**
	* Constructor
	*
	* @param DepartmentRepository $departmentRepository
	* @param EmployeeRepository $employeeRepository
	*/
	function __construct(DepartmentRepository $departmentRepository, EmployeeRepository $employeeRepository) {
		$this->departmentRepository = $departmentRepository;
		$this->employeeRepository = $employeeRepository;
	}

	/**
	* Handles the command.
	*
	* @param RestoreDepartmentCommand $command
	* @return Department
	*/
	public function handle($command) {
		$departmentRestore = $this->departmentRepository->restore($command->department_id);

		return $departmentRestore;
	}
}
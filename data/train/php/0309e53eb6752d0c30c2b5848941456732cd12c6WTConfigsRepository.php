<?php
use WTConfigs as WTConfigs;
use Respect\Validation\Validator as Validator;

class WTConfigsRepository extends BaseRepository {

	protected $employeeRepository,$payrollGroupRepository,$payslipsGroupRepository;
	
	public function __construct()
	{
		$this->class = new WTConfigs();

		$this->employeeRepository = new EmployeeRepository();
        $this->payrollGroupRepository= new PayrollGroupRepository();
        $this->payslipsGroupRepository = new PayslipsGroupRepository();
	}

	
	public function createWt($data)
	{
            return $this->create($data);
	}

	public function updateWt($data , $id)
	{
            return $this->where('id','=',$id)->update($data);
	}
}
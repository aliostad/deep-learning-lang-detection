<?php
use SSSConfigs as SSSConfigs;
use Respect\Validation\Validator as Validator;

class SSSConfigsRepository extends BaseRepository {

	protected $employeeRepository,$payrollGroupRepository,$payslipsGroupRepository;
	
	public function __construct()
	{
		$this->class = new SSSConfigs();

		$this->employeeRepository = new EmployeeRepository();
        $this->payrollGroupRepository= new PayrollGroupRepository();
        $this->payslipsGroupRepository = new PayslipsGroupRepository();
	}

	
	public function createSSS($data)
	{

            return $this->create($data);

	}

	public function updateSSS($data , $id)
	{


            return $this->where('id','=',$id)->update($data);

	}
}
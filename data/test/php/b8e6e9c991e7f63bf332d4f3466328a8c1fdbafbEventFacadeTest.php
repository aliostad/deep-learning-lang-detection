<?php
require_once("../controllers/facadesControllers/EventFacade.php");
require_once("../models/interfaces/DataBase.php");
require_once("../models/interfaces/SessionInterface.php");
require_once("../models/validators/ValidatorsModel.php");
require_once("../config/config.php");

class EventFacadeTest extends PHPUnit_Framework_TestCase
{
	protected $eventFacade;
    protected $DB;
	public function __construct()
	{
		$this -> eventFacade = new EventFacade();
		$this -> DB = DataBase::getInstance();
	}
    public function testAttribute()
    {
        $this -> assertClassHasAttribute('DB', 'EventFacade');
        $this -> assertClassHasAttribute('session', 'EventFacade');
        $this -> assertClassHasAttribute('valid', 'EventFacade');
    }
	public function testGetEvent()
	{
		$r = $this -> eventFacade -> getEvent(1);
		$this -> assertTrue(is_array($r));
		$this -> assertNotEmpty($r);
	}
	public function testGetEmployees()
	{
		$r = $this -> eventFacade -> getEmployees();
		$this -> assertTrue(is_array($r));
		$this -> assertNotEmpty($r);
	}
	public function testGetEmployee()
	{
		$r = $this -> eventFacade -> getEmployee(1);
		$this -> assertTrue(is_array($r));
		$this -> assertNotEmpty($r);
	}
}
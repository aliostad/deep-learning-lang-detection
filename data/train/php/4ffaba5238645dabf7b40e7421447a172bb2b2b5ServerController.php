<?php  
require_once("../facade/ServerFacade.php");
class ServerController
{
	protected $facade;
	public function __construct()
	{
		$this -> facade = new ServerFacade();
	}
	public function getAllCars()
	{
		return $this -> facade -> getAllCars();
	}
	public function getDetail($id)
	{
		return $this -> facade -> getDetail($id);
	}
	public function order($id, $fname, $lname, $payType)
	{
		echo $id;
		return $this -> facade -> saveOrder($id, $fname, $lname, $payType);
	}
	public function getData()
	{
		return $this -> facade -> getData();
	}
	public function search($arr)
	{
		return $this -> facade -> search($arr);
	}
}  

$server = new SoapServer("test.wsdl");  
$server->setClass("ServerController");  
$server->handle();  
?> 
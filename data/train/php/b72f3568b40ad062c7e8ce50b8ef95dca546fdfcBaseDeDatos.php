<?php 
require_once 'HandlerBDInterface.php'; 
require_once 'Sql.php'; 

class BaseDeDatos 
{ 
	private $_handler; 
	public function __construct(HandlerBDInterface $handler) 
	{ 
		$this->_handler = $handler; 
	} 
	
	public function ejecutar(Sql $sql) 
	{ 
		$this->_handler->conectar(); 
		$datos = $this->_handler->consultar($sql); 
		$this->_handler->desconectar(); 
		return $datos; 
	}
	
	public function modificar(Sql $sql) 
	{ 
		$this->_handler->conectar(); 
		$datos = $this->_handler->modificar($sql); 
		$this->_handler->desconectar(); 
		return $datos; 
	}
}
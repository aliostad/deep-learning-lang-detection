<?php 
	require_once('persona.php');

	class Base
	{
		//Atributo
		private $perSave;
		
		/*
		* Constructor por defecto
		*/
		public function __construct($param)
		{
			$this->perSave = $param;
		}

		/*
		* Función para guardar la persona en la BBDD
		*/
		 public function guardar()
		 {

		$user = "root";
		$pwd = "1234";
			try
			{
				$nomSave = $this->perSave->getNombre();
				$fnSave = $this->perSave->getFNacimiento();
				$genSave = $this->perSave->getGenero();

				$host = new PDO("mysql:host=localhost;dbname=test", $user, $pwd);
				$host->exec("INSERT INTO test.persona(nombre,fn,genero) VALUES ('$nomSave','$fnSave','$genSave')");
				echo 'Ulitmo id insertado: '. $host->lastInsertId();

				$host = null;
			}
			catch (PDOException $e)
			{
				echo $e->getMessage();
			}
		}
	}

	class BDSave extends Base 
	{

	}
 ?>
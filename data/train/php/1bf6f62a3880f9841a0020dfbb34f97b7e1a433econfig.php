<?php

/**
 * Si aucun objet facade n'est trouve dans la session
 * une instance est cree avec les valeurs par defaut
 * (user=visiteur)
 */

		session_start();

if(!isset($_SESSION['facade'])){
//print 'creation facade';

	$facade=new facade();
	$user='visiteur';	
	$facade->type=$user;
	$facade->_init_Object();
}else{ 

 	$facade=$_SESSION['facade'];
	$facade->_get_requiredClass();
}

//recuperation de l'actiion dans $_REQUEST par defaut
//if(isset($_REQUEST['action'])){$action=$_REQUEST['action'];}else{$action=$facade->get_action();}
//$_SESSION['SERVEUR_PATH']="http://parsoflex.info/";
//$facade->set_action($action);
$_SESSION['facade']=$facade;

//  	print_r($_SESSION);

?>

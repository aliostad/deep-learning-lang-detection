<?php
// Open de sessie
ini_set('session.use_cookies', false);
session_id($_GET['session']);
session_start();

// prepare
$show = Array();

// check if there is something to show
if($_SESSION['p1ready'] === true && $_SESSION['p2ready'] === true){

	$show['action'] 	= $_SESSION['action'];
	
	$show['p1guess'] = $_SESSION['p1guess'];
	$show['p2guess'] = $_SESSION['p2guess'];
	
	if($_SESSION['p1guess'] == "stone" && $_SESSION['p2guess'] == "paper"){
		$show['win'] = 2;
	}else
	if($_SESSION['p1guess'] == "stone" && $_SESSION['p2guess'] == "scissors"){
		$show['win'] = 1;
	}else
	if($_SESSION['p1guess'] == "paper" && $_SESSION['p2guess'] == "scissors"){
		$show['win'] = 2;
	}else
	if($_SESSION['p1guess'] == "paper" && $_SESSION['p2guess'] == "stone"){
		$show['win'] = 1;
	}else
	if($_SESSION['p1guess'] == "scissors" && $_SESSION['p2guess'] == "stone"){
		$show['win'] = 2;
	}else
	if($_SESSION['p1guess'] == "scissors" && $_SESSION['p2guess'] == "paper"){
		$show['win'] = 1;
	}else{
		$show['win'] = 0;
	}
	
	if($_SESSION['action'] == "start"){
	
		if($show['win'] > 0){
			$_SESSION['score'][$show['win']]++;
		}
		$_SESSION['action'] = "result";
		
	}else
	if($_SESSION['waitcount'] == 1){
	
		$_SESSION['waitcount'] = 0;
		$_SESSION['action'] = "start";
		$_SESSION['p1ready'] = false;
		$_SESSION['p2ready'] = false;
		$_SESSION['p1guess'] = null;
		$_SESSION['p2guess'] = null;
		
	}else{
	
		$_SESSION['waitcount']++;
		
	}
	
	
}

// last shows
$show['action']	= $_SESSION['action'];
$show['score']	= $_SESSION['score'];

// show
echo json_encode($show);
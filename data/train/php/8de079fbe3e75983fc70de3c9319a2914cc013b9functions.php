<?php
	// home page
	function home(){
		showPage();
	}


	
	// inscription et login 
	function signup(){
		showPage();
	}

	function login(){
		showPage();
	}

	function logout(){
		showPage();
	}



	// affiche links home et autres
	function linksHome(){
		showPage();
	}

	function linksCreate(){
		showPage();
	}

	function questionEdit(){
		showPage();
	}

	function questionUpdate(){
		showPage();
	}



	// affiche page user et autres
	function userDetails(){
		showPage();
	}

	function userEdit(){
		showPage();
	}

	function usersHome(){
		showPage();
	}






	// Fonctions include de pages
	function showPage(){
		global $page;
		include("pages/".$page.".php");
	}
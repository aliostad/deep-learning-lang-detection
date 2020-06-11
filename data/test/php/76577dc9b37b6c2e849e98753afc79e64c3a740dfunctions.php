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



	// affiche questions home et autres
	function questionsHome(){
		showPage();
	}

	function questionDetails(){
		showPage();
	}

	function questionCreate(){
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



	// commentaires
	function commentsCreate(){
		showPage();
	}


	// réponses
	function answersCreate(){
		showPage();
	}

	function answersUpdate(){
		showPage();
	}

	function votes(){
		showPage();
	}






	// Fonctions include de pages
	function showPage(){
		global $page;
		include("pages/".$page.".php");
	}
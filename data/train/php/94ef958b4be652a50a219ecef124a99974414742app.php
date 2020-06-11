<?php

session_start();
date_default_timezone_set('America/New_York');

require("../lib/Toro.php");
require('AuthHandler.php');
require('RegistrationHandler.php');
require('QuestionDataHandler.php');
require('post_helper.php');
require('get_helper.php');
require('UserInfoHandler.php');
require('ExamHandler.php');
require('GradeHandler.php');
require('SelectHandler.php');
require('LogOut.php');
require('ExamReviewHandler.php');
require('QuestionHandler.php');

Toro::serve(array(
    "/auth"      		=> "AuthHandler",
    "/register" 		=> "RegisterHandler",
    "/exammaker" 		=> "ExamMakerHandler",
    "/question_data" 		=> "QuestionDataHandler",
    "/question" 		=> "QuestionHandler",
    "/user_info"	  	=> "UserInfoHandler",
    "/exam"         		=> "ExamHandler",
    "/exam/:number" 		=> "ExamHandler",
    "/grade"        		=> "GradeHandler",
    "/select_data"  		=> "SelectHandler",
    "/logout" 			=> "LogOut",
    "/examreview/:number" 	=> "ExamReviewHandler"
));

?>

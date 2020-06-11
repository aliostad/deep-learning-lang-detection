<?php

require('../lib/Toro.php');
require('../lib/hash.php');
require('sql_helper.php');
require('ExistHandler.php');
require('AuthHandler.php');
require('RegistrationHandler.php');
require('QuestionCreateHandler.php');
require('SubjectHandler.php');
require('LanguageHandler.php');
require('ExamHandler.php');
require('GradeHandler.php');
require('ExamAnswerHandler.php');


Toro::serve(array(
    "/user/auth"                => "AuthHandler",
    "/user/register"            => "RegistrationHandler",
    "/user/exist"               => "ExistHandler",
    "/question/subject/:alpha"  => "QuestionSubjectGetHandler",
    "/question/language/:alpha" => "QuestionLanguageGetHandler",
    "/question/:number"         => "QuestionCreateHandler",
    "/question"                 => "QuestionCreateHandler",
    "/language"                 => "LanguageHandler",
    "/subject"                  => "SubjectHandler",
    "/exam/:number"             => "ExamHandler",
    "/exam"                     => "ExamHandler",
    "/grade"                    => "GradeHandler",
    "/grade/:number"            => "GradeHandler",
    "/examanswer"               => "ExamAnswerHandler",
));

?>

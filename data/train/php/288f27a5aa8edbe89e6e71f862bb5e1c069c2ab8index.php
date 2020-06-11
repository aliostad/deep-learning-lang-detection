<?php
require_once("includes/initialize.php"); // MAke sure all necessary files are included
if (!isset($session))
{
   $session = mySession::getInstance();
}


$action = getRequest("action");

// if ($action == "contact")
// {
//    $session->save("content", "about/contact.php");
//    include_page('home.php');
//    exit;
// }
// if ($action == 'getFirstNames')
// {
//    $session->save("content", "home.php")
//    include_page('home.php');
//    exit;
// }
if ($action == "people")
{
   $session->save('content', 'people/people.php');
   if (isset($_REQUEST['letter']))
   {
      $session->save("page", "people");
      $session->save('type', 'lastnames');
      $letter = $_REQUEST['letter'];
      $session->save('key', 'letter');
      $session->save('value', $letter);
      $session->save('letter', $letter);
      $people = Person::getLastNames($letter);
      if ($people)
      {
         if (isset($letter))
         {
            include_page('home.php');
            exit;
         }
      }
   }
   else if (isset($_REQUEST['last_name']))
   {
      $session->save("page", "people");
      $session->save('type', 'firstnames');
      if (isset($_REQUEST['last_name']))
      {
         $lastname = $_REQUEST['last_name'];
         $session->save('key', 'lastname');
         $session->save('value', $lastname);
         $session->save('lastname', $lastname);
      }
      $people = Person::getFirstNames($lastname);
      if ($people)
      {
         if (isset($lastname))
         {
            include_page('home.php');
            exit;
         }
      }
   }
   include_page('home.php');
   exit;
}
// if ($action == "place")
// {
//    $session->save('content', 'place/place.php');
//    // $session->save('page', 'place');
//    // if (isset($_REQUEST['letter']))
//    // {
//    //    $session->save('type', 'place');
//    //    $letter = $_REQUEST['letter'];
//    //    $session->save('key', 'letter');
//    //    $session->save('value', $letter);
//    //    $session->save('letter', $letter);
//    // }
//    include_page('home.php');
//    exit;
// }
// if ($action == "cemetary")
// {
//    $session->save('content', 'cemetary/cemetary.php');
//    // $session->save('page', 'cemetary');
//    // if (isset($_REQUEST['letter']))
//    // {
//    //    $session->save('type', 'cemetary');
//    //    $letter = $_REQUEST['letter'];
//    //    $session->save('key', 'letter');
//    //    $session->save('value', $letter);
//    //    $session->save('letter', $letter);
//    // }  
//    // if (isset($letter))
//    // {
//    //    include_page('home.php');
//    //    exit;
//    // }
//    include_page('home.php');
//    exit;
// }
// if ($action == "mayflower")
// {
//    $session->save('content', 'mayflower/mayflower.php');
//    // $session->save('page', 'mayflower');
//    // if (isset($_REQUEST['letter']))
//    //    $letter = $_REQUEST['letter'];
//    // if (isset($letter))
//    // {
//    //    include_page('home.php');
//    //    exit;
//    // }
//    include_page('home.php');
//    exit;
// }
if ($action == "contact")
{
   $session->save('content', 'about/contact.php');
   include_page('home.php');
   exit;
}
if ($action == "about")
{
   $session->save('content', 'about/about.php');
   include_page('home.php');
   exit;
}
else
{
   $session->save('content', 'home.php');
   $session->save('page', 'home');
   include_page('home.php');
   exit;
}
// echo "whats up doc?";
exit;


?>
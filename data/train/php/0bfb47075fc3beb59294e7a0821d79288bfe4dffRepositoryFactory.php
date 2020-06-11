<?php
require_once("ExampleRepository.php") ;

function /*IRepository*/ createRepository($protocol,$repname,$logger) {
  // process the configuration parameters, perform some checks, etc
  
  // create the repository with appropriate parameters
  $logger->log("example::createRepository:: creating ExampleRepository") ;                 
  $repository = new ExampleRepository( 
                         // URL_REPOSITORY.$protocol.'$'.$repname."/",
                         // $rootdirectory,
                         //$rooturl,
                         //ABSPATH_LOGS."repository-".$protocol.'$'.$repname.".txt" 
                          ) ;
  $logger->log("example::createRepository:: repository successfully opened") ;                 
  return $repository ;
}

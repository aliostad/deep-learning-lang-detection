<?php
require_once("SRDFRepository.php") ;

function /*IRepository*/ createRepository($protocol,$repname,$logger) {
  $logger->log("srdf::createRepository:: creating SRDFRepository") ;                 
  $repository = new SRDFRepository( 
                         URL_REPOSITORY.$protocol.'$'.$repname."/",
                         $repname,
                         "repository-".$protocol.'$'.$repname.".txt"  ) ;
  $logger->log("srdf::createRepository:: repository opened") ;                 
  return $repository ;
}

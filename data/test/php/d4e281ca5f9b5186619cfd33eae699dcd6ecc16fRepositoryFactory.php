<?php
require_once("MetaRepository.php") ;

function /*IRepository*/ createRepository($protocol,$repname,$logger) {
  $directory=ABSPATH_MODELS ;
  assert('strlen($directory)>=1') ;
  
  // repname is in the form of model_perspectivename1_perspectivename2...
  // this is necessary since currently repository do not provides the list of perspective
  $segments=explode("_",$repname) ;
  $modelname =array_shift($segments) ;
  $perspectivesoids = $segments ;
  
  // open the repository with the model
  $jsonmodelfile = $directory.$modelname.'.model.json' ;
  $logger->log("meta::createRepository:: creating the model repository") ;
  $repositoryWithModel = new SimpleStringBasedInstanceEmptyRepository( 
                         URL_REPOSITORY.'sss$'.$modelname."/",
                         $jsonmodelfile,
                         ABSPATH_LOGS."repository-sss$".$modelname.".txt"  ) ;  
  if (! $repositoryWithModel) {
    $logger->log("meta::createRepository:: creation of the model repository failed!") ;
  } else {
    $logger->log("meta::createRepository:: success with the creation of the model repository") ;

  }  
  $logger->log("meta::createRepository:: creation of the metamodel repository") ;

  $metaRepository = new MetaQueryRepository(
                         URL_REPOSITORY.$protocol.'$'.$repname."/",
                         $repositoryWithModel,
                         $perspectivesoids,
                         ABSPATH_LOGS."repository-meta$".$repname.".txt" ) ;
  $logger->log("meta::createRepository:: metamodel repository successfully opened") ;
  
  return $metaRepository ;  
}

<?php  namespace Quallsbenson\Repository\RepositoryManagerBundle\RepositoryInitializer; 

use Quallsbenson\Repository\RepositoryInitializer;
use Quallsbenson\Repository\RepositoryManagerBundle\Repository\Entity3Repository;



class Entity3RepositoryInitializer extends RepositoryInitializer{

  public function initialize($repository, array $services = array()){

    if( ($repository instanceof Entity3Repository) === false)
      throw new \Exception('Repository must be an instance of Entity3Repository');

    parent::initialize($repository, $services);

  }

}

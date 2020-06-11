<?php  namespace Designplug\Repository\RepositoryManagerBundle\RepositoryInitializer; 

use Designplug\Repository\RepositoryInitializer;
use Designplug\Repository\RepositoryManagerBundle\Repository\Entity2Repository;



class Entity2RepositoryInitializer extends RepositoryInitializer{

  public function initialize($repository, array $services = array()){

    if( ($repository instanceof Entity2Repository) === false)
      throw new \Exception('Repository must be an instance of Entity2Repository');

    parent::initialize($repository, $services);

  }

}

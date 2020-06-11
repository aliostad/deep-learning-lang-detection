<?php  namespace Designplug\Repository\RepositoryManagerBundle\RepositoryInitializer; 

use Designplug\Repository\RepositoryInitializer;
use Designplug\Repository\RepositoryManagerBundle\Repository\EntityRepository;



class EntityRepositoryInitializer extends RepositoryInitializer{

  public function initialize($repository, array $services = array()){

    if( ($repository instanceof EntityRepository) === false)
      throw new \Exception('Repository must be an instance of EntityRepository');

    parent::initialize($repository, $services);

  }

}

<?php  namespace Quallsbenson\Repository\RepositoryManagerBundle\RepositoryInitializer; 

use Quallsbenson\Repository\RepositoryInitializer;
use Quallsbenson\Repository\RepositoryManagerBundle\Repository\EntityRepository;



class EntityRepositoryInitializer extends RepositoryInitializer{

  public function initialize($repository, array $services = array()){

    if( ($repository instanceof EntityRepository) === false)
      throw new \Exception('Repository must be an instance of EntityRepository');

    parent::initialize($repository, $services);

  }

}

<?php  namespace Designplug\Repository\Tests\Generator\RepositoryInitializer; 

use Designplug\Repository\RepositoryInitializer;
use Designplug\Repository\Tests\Generator\Repository\V1Repository;



class V1RepositoryInitializer extends RepositoryInitializer{

  public function initialize($repository, array $services = array()){

    if( ($repository instanceof V1Repository) === false)
      throw new \Exception('Repository must be an instance of V1Repository');

    parent::initialize($repository, $services);

  }

}

<?php  namespace Designplug\Repository\Tests\Generator\RepositoryInitializer; 

use Designplug\Repository\RepositoryInitializer;
use Designplug\Repository\Tests\Generator\Repository\Example123Repository;



class Example123RepositoryInitializer extends RepositoryInitializer{

  public function initialize($repository, array $services = array()){

    if( ($repository instanceof Example123Repository) === false)
      throw new \Exception('Repository must be an instance of Example123Repository');

    parent::initialize($repository, $services);

  }

}

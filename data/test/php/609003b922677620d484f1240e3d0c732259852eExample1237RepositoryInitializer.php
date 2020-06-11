<?php  namespace Designplug\Repository\Tests\Generator\RepositoryInitializer; 

use Designplug\Repository\RepositoryInitializer;
use Designplug\Repository\Tests\Generator\Repository\Example1237Repository;



class Example1237RepositoryInitializer extends RepositoryInitializer{

  public function initialize($repository, array $services = array()){

    if( ($repository instanceof Example1237Repository) === false)
      throw new \Exception('Repository must be an instance of Example1237Repository');

    parent::initialize($repository, $services);

  }

}

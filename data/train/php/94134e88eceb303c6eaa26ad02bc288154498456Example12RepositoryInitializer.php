<?php  namespace Designplug\Repository\Tests\Generator\RepositoryInitializer;


use Designplug\Repository\RepositoryInitializer;
use Designplug\Repository\Tests\Generator\Repository\Example12Repository;


class Example12RepositoryInitializer extends RepositoryInitializer{

  public function initialize($repository, array $services = array()){

    if( ($repository instanceof Example12Repository) === false)
      throw new \Exception('Repository must be an instance of Example12Repository');

    parent::initialize($repository, $services);

  }

}

<?php

namespace PGD;

class MultiRepositoryController 
{
  /**
   * @var \PGD\RepositoryInfoCollection
   */
  protected $repositoryCollection;
  
  public function __construct(\PGD\RepositoryInfoCollection $repositoryInfoCollection) 
  {
    $this->repositoryCollection = $repositoryInfoCollection;
  }
  
  public function getRepositories()
  {
    return $this->repositoryCollection;
  }
  
  public function getRepository($repositoryName)
  {
    return $this->getRepositories()->get($repositoryName);
  }
  
  public function hasRepository($repositoryName)
  {
    return $this->getRepositories()->has($repositoryName);
  }
    
  public function validRequest()
  {
    $requestedRepository = $this->getRequestedRepositoryName();
    if ($requestedRepository===false || $requestedRepository == '')
      return false;
    return $this->hasRepository($requestedRepository);    
  }
  
  public function getRequestedRepositoryName()
  {
    $requestedRepository = (isset($_GET['repository']) ? $_GET['repository'] : '');
    return $requestedRepository;
  }
  
  public function getRequestedRepository()
  {
    $repositoryName = $this->getRequestedRepositoryName();
    return $this->getRepositories()->get($repositoryName);
  }
  

}

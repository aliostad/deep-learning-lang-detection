<?php
/**
 * @package githubReleaseParser
 *
 *
 */

namespace GithubRP;



class GithubBaseInfo 
{
  protected $username;
  protected $repositoryName;
  
  function init($username, $repositoryName)
  {
    $this->username = $username;
    $this->repositoryName = $repositoryName;
  }
  
  function __construct($username, $repositoryName) 
  {
    $this->init($username, $repositoryName);
  }
  
  function getUsername()
  {
    return $this->username;
  }
  
  function getRepositoryName() 
  {
    return $this->repositoryName;
  }
  
  
}
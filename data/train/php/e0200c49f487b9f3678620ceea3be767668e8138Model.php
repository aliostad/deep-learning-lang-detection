<?php
abstract class Model implements JsonSerializable
{
    protected $repositories;

    public function __construct()
    {
        $this->repositories = array();

        if (is_array($this->usesRepositories))
        {
            foreach ($this->usesRepositories as $useRepository)
            {
                $repositoryName = $useRepository . 'Repository';

                require 'Application/Repository/' . $repositoryName . '.php';
                $this->repositories[$useRepository] = new $repositoryName();
            }
        }
    }
}
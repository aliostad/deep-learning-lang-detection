<?php
abstract class Model
{
    protected $repositories;

    public function __construct()
    {
        $this->repositories = array();

        if (is_array($this->usesRepositories))
        {
            foreach ($this->usesRepositories as $useRepository)
            {
                if ($useRepository == 'Core')
                {
                    $repositoryName = 'Repository';
                }
                else
                {
                    $repositoryName = $useRepository . 'Repository';
                    require INDEX_DIR . 'Application/Repository/' . $repositoryName . '.php';
                }

                $this->repositories[$useRepository] = new $repositoryName();
            }
        }
    }
}
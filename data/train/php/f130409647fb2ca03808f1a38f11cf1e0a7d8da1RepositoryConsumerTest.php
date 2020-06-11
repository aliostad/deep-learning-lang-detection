<?php

namespace SimpleIT;

/**
 * Trait which bring repository mocking to a test case
 *
 * @author Sylvain Mauduit <sylvain.mauduit@simple-it.fr>
 * @deprecated
 */
trait RepositoryConsumerTest
{
    protected static $mockedRepositories = array();

    protected static function registerRepositoryMock($repositoryClassName)
    {
        self::$mockedRepositories[$repositoryClassName] = null;
    }

    protected function getRepositoryMock($repositoryClassName)
    {
        if (array_key_exists($repositoryClassName, $this->mockedRepositories)) {

            $mockedRepository = $this->mockedRepositories[$repositoryClassName];
            if (is_null($mockedRepository)) {
                $mockedRepository = $this->getSingleMock(
                    $this->mockedRepositories[$repositoryClassName],
                    $repositoryClassName
                );
            }

            return $mockedRepository;

        } else {
            throw new \Exception('Repository '.$repositoryClassName.' is not registered.');
        }
    }
}

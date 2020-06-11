<?php
namespace Czim\Processor\Contracts;

use Czim\Repository\Contracts\BaseRepositoryInterface as RepositoryInterface;

interface ProcessContextRepositoryInterface
{

    /**
     * Adds repository to the context
     *
     * @param string              $name
     * @param RepositoryInterface $repository
     * @return $this
     */
    public function addRepository($name, RepositoryInterface $repository);

    /**
     * Returns stored repository
     *
     * @param  string $name
     * @return RepositoryInterface
     */
    public function getRepository($name);

    /**
     * Performs method call on repository and returns result
     *
     * @param  string $name
     * @param  string $method
     * @param  array  $parameters
     * @return mixed
     */
    public function repository($name, $method, array $parameters = array());

}

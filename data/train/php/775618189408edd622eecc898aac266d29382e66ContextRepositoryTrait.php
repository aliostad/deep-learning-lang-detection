<?php
namespace Czim\Processor\Contexts;

use Czim\Processor\Exceptions\ContextRepositoryException;
use Czim\Repository\Contracts\BaseRepositoryInterface as RepositoryInterface;

trait ContextRepositoryTrait
{

    /**
     * Repositories
     *
     * @var array
     */
    protected $repositories = [];


    /**
     * @param string              $name
     * @param RepositoryInterface $repository
     * @return $this
     */
    public function addRepository($name, RepositoryInterface $repository)
    {
        $this->repositories[$name] = $repository;

        return $this;
    }

    /**
     * @param string $name
     * @return RepositoryInterface
     * @throws ContextRepositoryException   if repository name not found
     */
    public function getRepository($name)
    {
        if ( ! array_key_exists($name, $this->repositories)) {

            throw new ContextRepositoryException("Repository by name not found: {$name}");
        }

        return $this->repositories[$name];
    }

    /**
     * Perform a method on a repository
     *
     * @param string $name
     * @param string $method
     * @param array  $parameters
     * @return mixed
     * @throws ContextRepositoryException   if repository name not found
     */
    public function repository($name, $method, array $parameters = [])
    {
        return call_user_func_array(
            [ $this->getRepository($name), $method ],
            $parameters
        );
    }
}

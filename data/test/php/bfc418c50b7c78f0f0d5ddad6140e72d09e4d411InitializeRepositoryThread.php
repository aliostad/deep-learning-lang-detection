<?php
namespace ACP3\Subtree\Thread;


use ACP3\Subtree\Repositories;

class InitializeRepositoryThread extends \Thread
{
    /**
     * @var array
     */
    private $repository;

    /**
     * InitializeRepositoriesThread constructor.
     * @param array $repository
     */
    public function __construct(array $repository)
    {
        $this->repository = $repository;
    }

    public function run()
    {
        $path = Repositories::getRepoDir() . $this->repository['directory'];
        if (!is_dir($path)) {
            print('Cloning: ' . $this->repository['url'] . "\n");
            exec("git clone {$this->repository['url']} {$path} -q");
        }
    }
}

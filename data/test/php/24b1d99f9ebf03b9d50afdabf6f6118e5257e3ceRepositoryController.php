<?php

namespace Gitory\Gitory\Controllers;

use Gitory\Gitory\Entities\Repository;
use Gitory\Gitory\Managers\RepositoryManager;
use Gitory\Gitory\Exceptions\ExistingRepositoryIdentifierException;
use Gitory\Gitory\API\Response;

class RepositoryController
{
    private $repositoryManager;

    public function __construct(RepositoryManager $repositoryManager)
    {
        $this->repositoryManager = $repositoryManager;
    }

    public function listAction()
    {
        $repositories = $this->repositoryManager->findAll();

        return new Response(array_map(function ($repository) {
            return ['identifier' => $repository->identifier()];
        }, $repositories));
    }

    public function createAction($identifier)
    {
        $repository = new Repository($identifier);
        try {
            $repository = $this->repositoryManager->save($repository);
        } catch(ExistingRepositoryIdentifierException $e) {
            return new Response([
                'id' => 'existing-repository-identifier-exception',
                'message' => $e->getMessage()
            ], Response::HTTP_CONFLICT);
        }

        return new Response([
            'identifier' => $repository->identifier()
        ], Response::HTTP_CREATED);
    }
}

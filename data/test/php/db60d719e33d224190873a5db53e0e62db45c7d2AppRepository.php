<?php  namespace Codeboard\Apps\Repositories; 

use Codeboard\Apps\Repository;
use Codeboard\Domains\Domain;

class AppRepository {

    public function addNewRepository($domainId, $repositoryData)
    {
        $domain = Domain::findOrFail($domainId);
        $repository = $domain->app()->create($repositoryData);
        return $repository;
    }

    public function unInstallRepository($repositoryId)
    {
        $repository = Repository::findOrFail($repositoryId);
        $repository->delete();
        return $repository;
    }

    public function updateRepository($repositoryId, $repositoryData)
    {
        $repository = Repository::findOrFail($repositoryId);
        $repository->update($repositoryData);
        return $repository;
    }

} 
<?php  namespace Codeboard\Apps; 
use Codeboard\Apps\Repositories\AppRepository;
use Illuminate\Log\Writer;

class AddNewApp {

    /**
     * @var Repositories\AppRepository
     */
    private $repository;
    /**
     * @var \Illuminate\Log\Writer
     */
    private $log;

    function __construct(AppRepository $repository, Writer $log)
    {
        $this->repository = $repository;
        $this->log = $log;
    }

    public function execute($domainId, $repositoryData, AppListener $listener)
    {
        $repository = $this->repository->addNewRepository($domainId, $repositoryData);
        $this->log->info('Repository created for DomainID: '. $domainId, $repository->toArray());
        return $listener->appRedirect($repository);
    }

} 
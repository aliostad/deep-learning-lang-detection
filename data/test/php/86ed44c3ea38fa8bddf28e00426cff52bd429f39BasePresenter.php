<?php

use \Nette\Application\UI\Presenter,
    \SokolKoseticeFeatures\Repositories;

/**
 * @author Jan Jíša <j.jisa@seznam.cz>
 * @package SokolKoseticeFeatures
 */
abstract class BasePresenter extends Presenter {

    /**
     * @var \DibiConnection
     */
    protected $databaseConnection;

    /**
     * @var Repositories\NewSiteRepository
     */
    protected $newSiteRepository;

    /**
     * @var Repositories\SimpleArticleRepository
     */
    protected $simpleArticleRepository;

    /**
     * @var Repositories\SchedulesGeneratorRepository
     */
    protected $schedulesGeneratorRepository;

    /**
     * @var Repositories\MatchesGeneratorRepository
     */
    protected $matchesGeneratorRepository;

    protected function startup() {
        parent::startup();
    }

    /**
     * Inject repositories
     * @param \DibiConnection $connection
     * @param Repositories\SimpleArticleRepository $simpleArticleRepository
     * @param Repositories\NewSiteRepository $newSiteRepository
     */
    public function injectBaseComponents(
            \DibiConnection $connection,
            Repositories\SimpleArticleRepository $simpleArticleRepository,
            Repositories\NewSiteRepository $newSiteRepository,
            Repositories\SchedulesGeneratorRepository $schedulesGeneratorRepository,
            Repositories\MatchesGeneratorRepository $matchesGeneratorRepository) {
        $this->databaseConnection = $connection;
        $this->simpleArticleRepository = $simpleArticleRepository;
        $this->newSiteRepository = $newSiteRepository;
        $this->schedulesGeneratorRepository = $schedulesGeneratorRepository;
        $this->matchesGeneratorRepository = $matchesGeneratorRepository;
    }

}

?>

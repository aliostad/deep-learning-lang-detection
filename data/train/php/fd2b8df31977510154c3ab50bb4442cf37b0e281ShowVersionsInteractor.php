<?php

namespace Metrics\Core\Interactor;

use Metrics\Core\Presenter\ShowVersionsPresenter;
use Metrics\Core\Repository\ProjectRepository;
use Metrics\Core\Repository\VersionRepository;

class ShowVersionsInteractor
{
    /**
     * @var VersionRepository
     */
    private $versionRepository;

    /**
     * @var ProjectRepository
     */
    private $projectRepository;

    /**
     * @var ShowVersionsPresenter
     */
    private $presenter;

    public function __construct(
        VersionRepository $versionRepository,
        ProjectRepository $projectRepository,
        ShowVersionsPresenter $presenter
    ) {
        $this->presenter = $presenter;
        $this->projectRepository = $projectRepository;
        $this->versionRepository = $versionRepository;
    }

    public function execute($projectName)
    {
        $project = $this->projectRepository->findOne($projectName);
        $versions = $this->versionRepository->findAll($project);
        return $this->presenter->present($versions);
    }
}

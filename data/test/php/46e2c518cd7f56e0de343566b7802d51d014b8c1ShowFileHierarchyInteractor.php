<?php

namespace Metrics\Core\Interactor;

use Metrics\Core\Entity\Project;
use Metrics\Core\Presenter\ShowFileHierarchyPresenter;
use Metrics\Core\Repository\FileVersionRepository;
use Metrics\Core\Repository\MetricRepository;
use Metrics\Core\Repository\ProjectRepository;
use Metrics\Core\Repository\VersionRepository;

class ShowFileHierarchyInteractor
{
    /**
     * @var FileVersionRepository
     */
    private $fileVersionRepository;

    /**
     * @var MetricRepository
     */
    private $metricsRepository;

    /**
     * @var VersionRepository
     */
    private $versionRepository;

    /**
     * @var ProjectRepository
     */
    private $projectRepository;

    /**
     * @var ShowFileHierarchyPresenter
     */
    private $presenter;

    /**
     * @param ProjectRepository $projectRepository
     * @param VersionRepository $versionRepository
     * @param FileVersionRepository $fileVersionRepository
     * @param MetricRepository $metricsRepository
     * @param ShowFileHierarchyPresenter $presenter
     */
    public function __construct(
        ProjectRepository $projectRepository,
        VersionRepository $versionRepository,
        FileVersionRepository $fileVersionRepository,
        MetricRepository $metricsRepository,
        ShowFileHierarchyPresenter $presenter
    ) {
        $this->projectRepository = $projectRepository;
        $this->versionRepository = $versionRepository;
        $this->fileVersionRepository = $fileVersionRepository;
        $this->metricsRepository = $metricsRepository;
        $this->presenter = $presenter;
    }

    /**
     * @param string $project
     * @param null $version
     * @return mixed
     */
    public function execute($project, $version = null)
    {
        $project = $this->projectRepository->findOne($project);
        if ($version == null) {
            $version = $this->versionRepository->findLatest($project);
        } else {
            $version = $this->versionRepository->findOne($project, $version);
        }
        $metrics = $this->metricsRepository->getMetrics();
        return $this->presenter->present($version, $metrics);
    }
}

<?php

namespace Metrics\Core\Interactor;

use Metrics\Core\Entity\MaterialType;
use Metrics\Core\Interactor\Sensor\Clover\CloverSensor;
use Metrics\Core\Interactor\Sensor\Phpcs\PhpcsSensor;
use Metrics\Core\Interactor\Sensor\Sensor;
use Metrics\Core\Repository\FileRepository;
use Metrics\Core\Repository\FileVersionRepository;
use Metrics\Core\Repository\MetricRepository;
use Metrics\Core\Repository\ProjectRepository;
use Metrics\Core\Repository\VersionRepository;

class AddMaterialInteractor
{
    /**
     * @var ProjectRepository
     */
    private $projectRepository;

    /**
     * @var VersionRepository
     */
    private $versionRepository;

    /**
     * @var FileRepository
     */
    private $fileRepository;

    /**
     * @var FileVersionRepository
     */
    private $fileVersionRepository;

    /**
     * @var MetricRepository
     */
    private $metricsRepository;

    public function __construct(
        $fileRepository,
        $fileVersionRepository,
        $metricsRepository,
        $projectRepository,
        $versionRepository
    ) {
        $this->fileRepository = $fileRepository;
        $this->fileVersionRepository = $fileVersionRepository;
        $this->metricsRepository = $metricsRepository;
        $this->projectRepository = $projectRepository;
        $this->versionRepository = $versionRepository;
    }


    public function execute($projectName, $versionLabel, $materialTypeName, $material)
    {
        /**
         * @var Sensor[] $sensors
         */
        $sensors = [
            new CloverSensor(
                $this->fileRepository,
                $this->fileVersionRepository,
                $this->metricsRepository
            ),
            new PhpcsSensor(
                $this->fileRepository,
                $this->fileVersionRepository,
                $this->metricsRepository
            )
        ];

        $project = $this->projectRepository->findOne($projectName);
        try {
            $version = $this->versionRepository->findOne($project, $versionLabel);
        } catch (\Exception $e) {
            $version = $this->versionRepository->create($project, $versionLabel);
        }
        $materialType = new MaterialType($materialTypeName);

        foreach ($sensors as $sensor) {
            if ($sensor->supportsMaterialType($materialType)) {
                $sensor->execute($material, $project, $version);
            }
        }

        $this->projectRepository->save($project);
        $this->versionRepository->save($version);
    }
}

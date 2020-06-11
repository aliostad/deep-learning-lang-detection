<?php

namespace Metrics\Web\Repository;

use Metrics\Core\Repository\ProjectRepository;
use Metrics\Core\Repository\SensorRepository;
use Metrics\Core\Repository\UserRepository;
use Metrics\Core\Repository\VersionRepository;

interface RepositoryFactory
{
    /**
     * @return ProjectRepository
     */
    public function getProjectRepository();

    /**
     * @return VersionRepository
     */
    public function getVersionRepository();

    /**
     * @return SensorRepository
     */
    public function getSensorRepository();

    /**
     * @return FileRepositoryMock
     */
    public function getFileRepository();

    /**
     * @return FileVersionRepositoryMock
     */
    public function getFileVersionRepository();

    /**
     * @return MetricRepositoryMock
     */
    public function getMetricsRepository();

    /**
     * @return UserRepository
     */
    public function getUserRepository();
}

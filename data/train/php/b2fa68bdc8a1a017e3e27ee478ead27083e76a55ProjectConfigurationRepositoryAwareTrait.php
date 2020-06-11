<?php

namespace Jarvis\Project\Repository;

use Jarvis\Project\Repository\ProjectConfigurationRepository;

trait ProjectConfigurationRepositoryAwareTrait
{
    /**
     * @var ProjectConfigurationRepository
     */
    private $projectConfigurationRepository;

    /**
     * @param ProjectConfigurationRepository $repository
     */
    public function setProjectConfigurationRepository(ProjectConfigurationRepository $repository)
    {
        $this->projectConfigurationRepository = $repository;
    }
    /**
     * @return string
     */
    protected function getProjectConfigurationRepository()
    {
        if (null === $this->projectConfigurationRepository) {
            throw new \RuntimeException('The project configuration repository service does not injected.');
        }

        return $this->projectConfigurationRepository;
    }
}

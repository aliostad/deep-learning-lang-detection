<?php

namespace Birgit\Core\Model;

use Birgit\Core\Model\Project\ProjectRepositoryInterface;
use Birgit\Core\Model\Project\Reference\ProjectReferenceRepositoryInterface;
use Birgit\Core\Model\Project\Reference\Revision\ProjectReferenceRevisionRepositoryInterface;
use Birgit\Core\Model\Project\Environment\ProjectEnvironmentRepositoryInterface;
use Birgit\Core\Model\Host\HostRepositoryInterface;
use Birgit\Core\Model\Build\BuildRepositoryInterface;

/**
 * Model Repository Manager
 */
class ModelRepositoryManager
{
    protected $projectRepository;
    protected $projectReferenceRepository;
    protected $projectReferenceRevisionRepository;
    protected $projectEnvironmentRepository;
    protected $hostRepository;
    protected $buildRepository;

    public function __construct(
        ProjectRepositoryInterface $projectRepository,
        ProjectReferenceRepositoryInterface $projectReferenceRepository,
        ProjectReferenceRevisionRepositoryInterface $projectReferenceRevisionRepository,
        ProjectEnvironmentRepositoryInterface $projectEnvironmentRepository,
        HostRepositoryInterface $hostRepository,
        BuildRepositoryInterface $buildRepository
    ) {
        $this->projectRepository = $projectRepository;
        $this->projectReferenceRepository = $projectReferenceRepository;
        $this->projectReferenceRevisionRepository = $projectReferenceRevisionRepository;
        $this->projectEnvironmentRepository = $projectEnvironmentRepository;
        $this->hostRepository = $hostRepository;
        $this->buildRepository = $buildRepository;
    }

    /**
     * Get project repository
     *
     * @return ProjectRepositoryInterface
     */
    public function getProjectRepository()
    {
        return $this->projectRepository;
    }

    /**
     * Get project reference repository
     *
     * @return projectReferenceRepository
     */
    public function getProjectReferenceRepository()
    {
        return $this->projectReferenceRepository;
    }

    /**
     * Get project reference revision repository
     *
     * @return projectReferenceRevisionRepository
     */
    public function getProjectReferenceRevisionRepository()
    {
        return $this->projectReferenceRevisionRepository;
    }

    /**
     * Get project environment repository
     *
     * @return ProjectEnvironmentRepositoryInterface
     */
    public function getProjectEnvironmentRepository()
    {
        return $this->projectEnvironmentRepository;
    }

    /**
     * Get host repository
     *
     * @return HostRepositoryInterface
     */
    public function getHostRepository()
    {
        return $this->hostRepository;
    }

    /**
     * Get build repository
     *
     * @return BuildRepositoryInterface
     */
    public function getBuildRepository()
    {
        return $this->buildRepository;
    }
}

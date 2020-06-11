<?php

namespace Deploy\Controller;

use Zend\Mvc\Controller\AbstractActionController;
use Deploy\Service\ProjectService;
use Deploy\Service\DeploymentService;
use Deploy\Service\UserService;

class ViewHistoryController extends AbstractActionController
{
    /**
     * @var \Deploy\Service\ProjectService
     */
    protected $projectService;

    /**
     * @var \Deploy\Service\DeploymentService
     */
    protected $deploymentService;

    /**
     * @var \Deploy\Service\UserService
     */
    protected $userService;

    public function __construct(
        ProjectService $projectService,
        DeploymentService $deploymentService,
        UserService $userService
    ) {
        $this->projectService = $projectService;
        $this->deploymentService = $deploymentService;
        $this->userService = $userService;
    }

    public function indexAction()
    {
        $project = $this->projectService->findByName($this->params('project'));

        $deployments = $this->deploymentService->findByProjectId($project->getId());
        $deployments->buffer();

        $users = [];

        foreach ($deployments as $deployment) {
            $userId = $deployment->getUserId();
            if (!isset($users[$userId])) {
                $user = $this->userService->findById($userId);
                $users[$userId] = $user;
            }
        }

        return [
            'project' => $project,
            'deployments' => $deployments,
            'users' => $users,
        ];
    }
}

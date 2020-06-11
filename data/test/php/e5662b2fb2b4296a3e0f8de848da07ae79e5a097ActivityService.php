<?php namespace Services;

use Repositories\ActivityRepositoryInterface as ActivityRepository;
use Services\ActivityServiceInterface;

class ActivityService extends AbstractRepositoryService implements ActivityServiceInterface
{
    protected $errors;
    protected $activityRepository;

    public function __construct(ActivityRepository $activityRepository)
    {
        $this->activityRepository = $this->setRepository($activityRepository);
    }

    public function getDeleted()
    {
        return $this->activityRepository->deletedActivities();
    }
}

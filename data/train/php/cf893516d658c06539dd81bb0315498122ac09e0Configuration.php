<?php

namespace Ice\FormBundle\Infrastructure;

use Ice\FormBundle\Repository\CourseRepositoryInterface;
use Ice\FormBundle\Repository\CourseApplicationRepositoryInterface;

class Configuration
{
    /**
     * @var CourseRepositoryInterface
     */
    private $courseRepository = null;

    /**
     * @var CourseApplicationRepositoryInterface
     */
    private $courseApplicationRepository = null;

    /**
     * @param \Ice\FormBundle\Repository\CourseRepositoryInterface $courseRepository
     * @return Configuration
     */
    public function setCourseRepository($courseRepository)
    {
        $this->courseRepository = $courseRepository;
        return $this;
    }

    /**
     * @return \Ice\FormBundle\Repository\CourseRepositoryInterface
     */
    public function getCourseRepository()
    {
        return $this->courseRepository;
    }

    /**
     * @param \Ice\FormBundle\Repository\CourseApplicationRepositoryInterface $courseApplicationRepository
     * @return Configuration
     */
    public function setCourseApplicationRepository($courseApplicationRepository)
    {
        $this->courseApplicationRepository = $courseApplicationRepository;
        return $this;
    }

    /**
     * @return \Ice\FormBundle\Repository\CourseApplicationRepositoryInterface
     */
    public function getCourseApplicationRepository()
    {
        return $this->courseApplicationRepository;
    }
}

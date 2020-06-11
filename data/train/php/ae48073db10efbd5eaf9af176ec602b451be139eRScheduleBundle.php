<?php

namespace RSchedule\Bundle\RScheduleBundle;

use RSchedule\Bundle\RScheduleBundle\Entity\RepositoryRegistry;
use Symfony\Component\HttpKernel\Bundle\Bundle;

class RScheduleBundle extends Bundle
{

    private $repositoryRegistry;

    /**
     * RSchedule\Bundle\RScheduleBundle\Entity\RepositoryRegistry
     */
    public function getRepositoryRegistry()
    {
        if (!$this->isInstanceRepositoryRegistry()) {
            $em = $this->container->get('doctrine')->getManager();
            $this->repositoryRegistry = new RepositoryRegistry($em);
        }

        return $this->repositoryRegistry;
    }

    /**
     * @return bool
     */
    public function isInstanceRepositoryRegistry()
    {
        return $this->repositoryRegistry instanceof RepositoryRegistry;
    }
}

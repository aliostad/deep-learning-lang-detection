<?php

namespace AppBundle\Entity\Attribute\Accessor;

use AppBundle\Entity\Service as ServiceEntity;

/**
 * Trait Service
 */
trait Service
{
    /**
     * Set service
     *
     * @param \AppBundle\Entity\Service $service
     * @return object
     */
    public function setService(ServiceEntity $service = null)
    {
        $this->service = $service;

        return $this;
    }

    /**
     * Get service
     *
     * @return \AppBundle\Entity\Service
     */
    public function getService()
    {
        return $this->service;
    }
}

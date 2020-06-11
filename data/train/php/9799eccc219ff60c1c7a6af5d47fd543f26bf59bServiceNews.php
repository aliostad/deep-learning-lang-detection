<?php

namespace CondoBundle\Entity;

use Doctrine\ORM\Mapping as ORM;

/**
 * NewsService.
 *
 * @ORM\Table(name="news_service")
 * @ORM\Entity(repositoryClass="CondoBundle\Repository\ServiceNewsRepository")
 */
class ServiceNews extends News
{
    /**
     * @var Service
     *
     * @ORM\JoinColumn(nullable=false)
     * @ORM\ManyToOne(
     *     targetEntity="CondoBundle\Entity\Service"
     * )
     */
    private $service;

    // region Accessors

    /**
     * @return Service
     */
    public function getService()
    {
        return $this->service;
    }

    /**
     * @param Service $service
     *
     * @return ServiceNews
     */
    public function setService(Service $service)
    {
        $this->service = $service;

        return $this;
    }

    // endregion
}

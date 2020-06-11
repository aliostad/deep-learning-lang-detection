<?php

namespace Oktolab\Bundle\RentBundle\Model\Event\Calendar;

use Doctrine\ORM\EntityRepository;

/**
 * Manages the EventCalendar
 */
class BaseAggregator
{

    /**
     * @var array
     */
    protected $repositories = array();

    /**
     * Adds a Repository.
     *
     * @param string                         $name
     * @param \Doctrine\ORM\EntityRepository $repository
     */
    public function addRepository($name, EntityRepository $repository)
    {
        $this->repositories[strtolower($name)] = $repository;
    }

    /**
     * Returns Repository by name.
     *
     * @param string $name
     * @return \Doctrine\ORM\EntityRepository|null
     */
    public function getRepository($name)
    {
        return isset($this->repositories[strtolower($name)]) ? $this->repositories[strtolower($name)] : null;
    }
}

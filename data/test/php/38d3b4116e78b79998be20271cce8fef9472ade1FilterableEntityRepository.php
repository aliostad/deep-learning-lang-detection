<?php

namespace Spray\PersistenceBundle\Repository;

use Doctrine\ORM\EntityRepository as DoctrineEntityRepository;

/**
 * A filterable entity repository
 * 
 * Instead of just passing data around, this Repository has a state that you can
 * alter with the use of EntityFilters.
 *
 * @author MHWK
 */
class FilterableEntityRepository extends DoctrineEntityRepository
    implements RepositoryFilterInterface
{
    /**
     * @var RepositoryFilterInterface
     */
    private $repositoryFilter;
    
    /**
     * On clone:
     * - also clone the repositoryFilter
     * 
     * @return void
     */
    public function __clone()
    {
        parent::__clone();
        if (null !== $this->repositoryFilter) {
            $this->repositoryFilter = clone $this->repositoryFilter;
        }
    }
    
    /**
     * Set repository filter
     * 
     * @param RepositoryFilterInterface $repositoryFilter
     * @return void
     */
    public function setRepositoryFilter(RepositoryFilterInterface $repositoryFilter)
    {
        $this->repositoryFilter = $repositoryFilter;
    }
    
    /**
     * Get repository filter
     * 
     * @return RepositoryFilterInterface
     */
    public function getRepositoryFilter()
    {
        if (null === $this->repositoryFilter) {
            $this->setRepositoryFilter(new RepositoryFilter($this));
        }
        return $this->repositoryFilter;
    }

    /**
     * {@inheritdoc}
     */
    public function count()
    {
        return $this->getRepositoryFilter()->count();
    }

    /**
     * {@inheritdoc}
     */
    public function current()
    {
        return $this->getRepositoryFilter()->current();
    }

    /**
     * {@inheritdoc}
     */
    public function key()
    {
        return $this->getRepositoryFilter()->key();
    }

    /**
     * {@inheritdoc}
     */
    public function next()
    {
        return $this->getRepositoryFilter()->next();
    }

    /**
     * {@inheritdoc}
     */
    public function rewind()
    {
        return $this->getRepositoryFilter()->rewind();
    }

    /**
     * {@inheritdoc}
     */
    public function valid()
    {
        return $this->getRepositoryFilter()->valid();
    }

    /**
     * {@inheritdoc}
     */
    public function filter($filter, $options = array())
    {
        return $this->getRepositoryFilter()->filter($filter, $options);
    }

    /**
     * {@inheritdoc}
     */
    public function paginate($page = 1, $itemsPerPage = 20)
    {
        return $this->getRepositoryFilter()->paginate($page, $itemsPerPage);
    }
}
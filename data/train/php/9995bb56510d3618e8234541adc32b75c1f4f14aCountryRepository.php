<?php

namespace Repository;

/**
 * Class CountryRepositoryException
 * @package Repository
 */
class CountryRepositoryException extends \Exception {}

/**
 * Class CountryRepository
 * @package Repository
 */
class CountryRepository extends EntityRepository {
    /**
     * @param \Doctrine\ORM\EntityManager $em
     * @param \Doctrine\ORM\Mapping\ClassMetadata $class
     */
    public function __construct(\Doctrine\ORM\EntityManager $em, \Doctrine\ORM\Mapping\ClassMetadata $class)
    {
        parent::__construct($em, $class);
    }
}

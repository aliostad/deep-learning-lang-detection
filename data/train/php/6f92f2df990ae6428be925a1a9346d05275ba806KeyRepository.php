<?php

namespace Repository;

/**
 * Class KeyRepositoryException
 * @package Repository
 */
class KeyRepositoryException extends \Exception {}

/**
 * Class KeyRepository
 * @package Repository
 */
class KeyRepository extends EntityRepository {
    /**
     * @param \Doctrine\ORM\EntityManager $em
     * @param \Doctrine\ORM\Mapping\ClassMetadata $class
     */
    public function __construct(\Doctrine\ORM\EntityManager $em, \Doctrine\ORM\Mapping\ClassMetadata $class)
    {
        parent::__construct($em, $class);
    }
}

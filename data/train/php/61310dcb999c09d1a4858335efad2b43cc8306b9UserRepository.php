<?php

namespace Repository;

/**
 * Class UserRepositoryException
 * @package Repository
 */
class UserRepositoryException extends \Exception {}

/**
 * Class UserRepository
 * @package Repository
 */
class UserRepository extends EntityRepository {
    /**
     * @param \Doctrine\ORM\EntityManager $em
     * @param \Doctrine\ORM\Mapping\ClassMetadata $class
     */
    public function __construct(\Doctrine\ORM\EntityManager $em, \Doctrine\ORM\Mapping\ClassMetadata $class)
    {
        parent::__construct($em, $class);
    }
}

<?php

namespace Repository;

/**
 * Class OrderRepositoryException
 * @package Repository
 */
class OrderRepositoryException extends \Exception {}

/**
 * Class OrderRepository
 * @package Repository
 */
class OrderRepository extends EntityRepository {
    /**
     * @param \Doctrine\ORM\EntityManager $em
     * @param \Doctrine\ORM\Mapping\ClassMetadata $class
     */
    public function __construct(\Doctrine\ORM\EntityManager $em, \Doctrine\ORM\Mapping\ClassMetadata $class)
    {
        parent::__construct($em, $class);
    }
}

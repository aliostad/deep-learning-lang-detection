<?php

namespace Repository;

/**
 * Class ProductRepositoryException
 * @package Repository
 */
class ProductRepositoryException extends \Exception {}

/**
 * Class ProductRepository
 * @package Repository
 */
class ProductRepository extends EntityRepository {
    /**
     * @param \Doctrine\ORM\EntityManager $em
     * @param \Doctrine\ORM\Mapping\ClassMetadata $class
     */
    public function __construct(\Doctrine\ORM\EntityManager $em, \Doctrine\ORM\Mapping\ClassMetadata $class)
    {
        parent::__construct($em, $class);
    }
}

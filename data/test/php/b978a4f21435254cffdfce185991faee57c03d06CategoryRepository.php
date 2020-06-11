<?php

namespace Repository;

/**
 * Class CategoryRepositoryException
 * @package Repository
 */
class CategoryRepositoryException extends \Exception {}

/**
 * Class CategoryRepository
 * @package Repository
 */
class CategoryRepository extends EntityRepository {
    /**
     * @param \Doctrine\ORM\EntityManager $em
     * @param \Doctrine\ORM\Mapping\ClassMetadata $class
     */
    public function __construct(\Doctrine\ORM\EntityManager $em, \Doctrine\ORM\Mapping\ClassMetadata $class)
    {
        parent::__construct($em, $class);
    }
}

<?php

namespace Symetria\ArticleBundle\Repository;

use Doctrine\ORM\EntityRepository;

/**
 * Class CategoryRepository
 * @package Symetria\ArticleBundle\Repository
 */
class CategoryRepository extends EntityRepository
{
    /**
     * Pobiera listę kategorii
     *
     * @return array
     */
    public function getCategories()
    {
        $repository = $this->getEntityManager()->getRepository('ArticleBundle:Category');
        $categories = $repository->findBy([], ['name' => 'ASC']);

        return $categories;
    }
}
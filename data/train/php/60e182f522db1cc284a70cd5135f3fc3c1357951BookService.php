<?php

namespace Teachi\MaterialBundle\Service;

use Doctrine\ORM\EntityManager,
    Doctrine\ORM\EntityRepository;

class BookService
{
    /**
     * @var EntityManager
     */
    private $em;

    /**
     * @var BookRepository
     */
    private $repository;

    public function __construct(EntityManager $em, EntityRepository $repository)
    {
        $this->em         = $em;
        $this->repository = $repository;
    }

    /**
     * @param  string $link 
     * @return Book
     */
    public function getBookByLink($link)
    {
        return $this->repository->findOneBy(array('link' => $link));
    }
}
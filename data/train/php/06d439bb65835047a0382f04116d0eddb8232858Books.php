<?php
namespace Lcobucci\Library\Books\Controllers;

use Lcobucci\ActionMapper2\Routing\Annotation\Inject;
use Lcobucci\ActionMapper2\Routing\Annotation\Route;
use Lcobucci\ActionMapper2\Routing\Controller;
use Lcobucci\Library\Books\BookRepository;

/**
 * @author Luís Otávio Cobucci Oblonczyk <luis@darwinsoft.com.br>
 */
class Books extends Controller
{
    /**
     * @var BookRepository
     */
    private $repository;

    /**
     * @Inject("books.repository")
     *
     * @param BookRepository $repository
     */
    public function __construct(BookRepository $repository)
    {
        $this->repository = $repository;
    }

    /**
     * @Route("/", methods={"GET"})
     */
    public function listAll()
    {
        return json_encode($this->repository->findAll());
    }
}

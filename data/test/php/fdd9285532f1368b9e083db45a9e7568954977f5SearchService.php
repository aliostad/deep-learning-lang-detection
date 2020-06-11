<?php
namespace MunKirjat\BookBundle\Service;

class SearchService 
{
    /**
     * @var AuthorService
     */
    protected $authorService;

    /**
     * @var BookService
     */
    protected $bookService;

    /**
     * @param AuthorService $authorService
     * @param BookService   $bookService
     */
    public function __construct(AuthorService $authorService, BookService $bookService)
    {
        $this->authorService    = $authorService;
        $this->bookService      = $bookService;
    }

    /**
     * @param string $term
     *
     * @return array
     */
    public function searchByTerm($term)
    {
        $results = array(
            'authors'   => $this->authorService->searchAuthors($term),
            'books'     => $this->bookService->searchBooks($term),
        );

        return $results;
    }

}

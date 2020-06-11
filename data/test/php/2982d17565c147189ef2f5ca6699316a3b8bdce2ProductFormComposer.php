<?php namespace Swapshop\Http\Composers;

use Swapshop\Tag\TagRepositoryInterface;

class ProductFormComposer
{
    /**
     * @var TagRepositoryInterface
     */
    private $tagRepository;

    /**
     * @param TagRepositoryInterface $tagRepository
     */
    public function __construct(TagRepositoryInterface $tagRepository)
    {
        $this->tagRepository = $tagRepository;
    }

    /**
     * @param $view
     */
    public function compose($view)
    {
        $tags = $this->tagRepository->getAllKeyValue();

        $view->with('tags', $tags);
    }
}
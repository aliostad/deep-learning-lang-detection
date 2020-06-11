<?php
namespace Wandu\Laravel\Repository\Stubs\Repository;

use Wandu\Laravel\Repository\MoreItemsRepositoryInterface;
use Wandu\Laravel\Repository\Repository;
use Wandu\Laravel\Repository\Stubs\Model\Article;
use Wandu\Laravel\Repository\Traits\UseMoreItemsRepository;

class ArticleRepository extends Repository implements MoreItemsRepositoryInterface
{
    use UseMoreItemsRepository;

    /** @var string */
    protected $model = Article::class;

    /** @var \Wandu\Laravel\Repository\Stubs\Repository\ArticleHitRepository */
    protected $hits;

    /** @var \Wandu\Laravel\Repository\Stubs\Repository\CategoryRepository */
    protected $categories;

    /**
     * @param \Wandu\Laravel\Repository\Stubs\Repository\ArticleHitRepository $hits
     * @param \Wandu\Laravel\Repository\Stubs\Repository\CategoryRepository $categories
     */
    public function __construct(ArticleHitRepository $hits, CategoryRepository $categories)
    {
        $this->hits = $hits;
        $this->categories = $categories;
    }
}

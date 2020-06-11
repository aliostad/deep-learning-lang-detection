<?php

use Acme\Category\CategoryRepository;
use Acme\Country\CountryRepository;
use Acme\Product\ProductRepository;
use Acme\Tag\TagRepository;
use Acme\User\UserRepository;

class ProductsController extends BaseController {

    /**
     * @var ProductRepository
     */
    private $productRepository;
    /**
     * @var CategoryRepository
     */
    private $categoryRepository;
    /**
     * @var TagRepository
     */
    private $tagRepository;

    /**
     * @param TagRepository $tagRepository
     * @param CategoryRepository $categoryRepository
     * @param ProductRepository $productRepository
     * @internal param UserRepository $userRepository
     * @internal param CountryRepository $countryRepository
     */
    public function __construct(TagRepository $tagRepository, CategoryRepository $categoryRepository, ProductRepository $productRepository)
    {
        $this->productRepository  = $productRepository;
        $this->categoryRepository = $categoryRepository;
        $this->tagRepository      = $tagRepository;
        parent::__construct();
    }

    public function index()
    {
        $posts      = $this->productRepository->getAllPaginated();
        $categories = $this->categoryRepository->getByType('Product')->get();
        $tags       = $this->tagRepository->getBlogTags();
        $this->render('site.products.index', compact('posts', 'categories', 'tags'));
    }

    /**
     * View a blog post.
     *
     * @param $id
     * @internal param string $slug
     * @return View
     */
    public function show($id)
    {
        // Get this blog post data
        $post = $this->productRepository->findById($id, ['category', 'photos']);

        $this->title = $post->title;

        $this->render('site.products.view', compact('post'));
    }
}
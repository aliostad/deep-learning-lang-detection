<?php

use Acme\Blog\BlogRepository;
use Acme\Category\CategoryRepository;
use Acme\EventModel\EventRepository;

class CategoriesController extends BaseController {

    /**
     * Category Repository
     *
     * @var Category
     */
    protected $categoryRepository;
    /**
     * @var BlogRepository
     */
    private $blogRepository;
    /**
     * @var EventRepository
     */
    private $eventRepository;

    /**
     * @param CategoryRepository $categoryRepository
     * @param BlogRepository $blogRepository
     * @param EventRepository $eventRepository
     */
    public function __construct(CategoryRepository $categoryRepository, BlogRepository $blogRepository, EventRepository $eventRepository)
    {
        $this->categoryRepository = $categoryRepository;
        $this->blogRepository     = $blogRepository;
        $this->eventRepository    = $eventRepository;
        parent::__construct();
    }

    public function getEvents($categoryID)
    {
        $category = $this->categoryRepository->findById($categoryID);
        $events     = $this->eventRepository->model->where('category_id', $category->id)->paginate(5);
        $categories = $this->categoryRepository->getEventCategories()->get();

        $this->title = $category->name;
        $this->render('site.category.events', compact('events', 'categories'));
    }

    public function getPosts($categoryID)
    {
        $category = $this->categoryRepository->findById($categoryID);
        $posts      = $this->blogRepository->model->where('category_id', $category->id)->paginate(5);
        $categories = $this->categoryRepository->getPostCategories()->get();

        $this->title = $category->name;
        $this->render('site.category.blogs', compact('posts', 'categories'));
    }
}

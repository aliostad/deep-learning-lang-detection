<?php

use Acme\Blog\BlogRepository;
use Acme\Category\CategoryRepository;
use Acme\Tag\TagRepository;
use Acme\User\UserRepository;

class BlogsController extends BaseController {

    protected $model;
    /**
     * @var Acme\Blog\BlogRepository
     */
    private $blogRepository;
    /**
     * @var Acme\Users\UserRepository
     */
    private $userRepository;
    /**
     * @var CategoryRepository
     */
    private $categoryRepository;
    /**
     * @var TagRepository
     */
    private $tagRepository;

    /**
     * @param BlogRepository $blogRepository
     * @param UserRepository $userRepository
     * @param CategoryRepository $categoryRepository
     * @param TagRepository $tagRepository
     */
    public function __construct(BlogRepository $blogRepository, UserRepository $userRepository, CategoryRepository $categoryRepository, TagRepository $tagRepository){

        $this->blogRepository = $blogRepository;
        $this->userRepository = $userRepository;
        $this->categoryRepository = $categoryRepository;
        $this->tagRepository = $tagRepository;
        parent::__construct();
    }
    
	/**
	 * Returns all the blog posts.
	 *
	 * @return View
	 */
	public function index()
	{
		// Get all the blog posts
        $this->title =  trans('word.blog');

        $posts = $this->blogRepository->getAllPaginated(['category','photos','author']);

        $categories = $this->categoryRepository->getPostCategories()->get();

        $tags = $this->tagRepository->getBlogTags();
		// Show the page
        $this->render('site.blog.index', compact('posts','categories','tags'));
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
		$post = $this->blogRepository->findById($id,['category','photos','author']);

        $this->title =  $post->title;

        $this->render('site.blog.view', compact('post'));
	}

    /**
     * Get Posts For Consultancies
     */
    public function consultancy() {

        $this->title =  trans('word.consultancies');

        $posts=  $this->blogRepository->getConsultancyPosts();

        $this->render('site.blog.consultancy', compact('posts'));
    }
}

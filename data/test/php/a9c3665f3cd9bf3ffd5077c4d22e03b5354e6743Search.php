<?php namespace Fashion\Services\Search;


use Fashion\Repos\Product\ProductRepository;
use Fashion\Repos\Category\CategoryRepository;

class Search  {

	
	protected $productRepository;
	protected $categoryRepository;    
	
	
	function __construct(ProductRepository $productRepository, CategoryRepository $categoryRepository)
	{
		$this->productRepository = $productRepository;
		$this->categoryRepository = $categoryRepository;
		
	}
	
	public function products($search, $limit = 15)
	{
		return $this->productRepository->search($search)->with('categories')->has('categories')->where('published', '=', 1)->paginate($limit);
	}

	public function categories($search, $limit = 15)
	{
		return $this->categoryRepository->search($search)->where('published', '=', 1)->paginate($limit);
	}

}
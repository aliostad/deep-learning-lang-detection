<?php namespace Rhine\Actions\Shop;

use Laravel\View;
use Laravel\Response;
use Rhine\Repositories\CategoryRepository;
use Rhine\Repositories\ProductRepository;

class ShopGetCategoryAction
{

	private $categoryRepository;
	private $productRepository;

	function __construct(CategoryRepository $categoryRepository, ProductRepository $productRepository)
	{
		$this->categoryRepository = $categoryRepository;
		$this->productRepository = $productRepository;
	}

	/**
	 * @return View
	 */
	public function execute($id)
	{
		$category = $this->categoryRepository->findById($id);
		
		if (is_null($category)) {
			return Response::error('404');
		}

		$categories = $this->categoryRepository->findAllOrdered();
		$products = $this->productRepository->findByCategoryOrderedAndPaginated($category);
		$activeCategory = $id;

		return View::make('shop.index')
		->with(compact('categories'))
		->with(compact('products'))
		->with(compact('activeCategory'));
	}

}

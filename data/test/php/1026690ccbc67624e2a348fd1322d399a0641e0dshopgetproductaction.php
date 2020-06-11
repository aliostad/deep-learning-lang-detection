<?php namespace Rhine\Actions\Shop;

use Laravel\View;
use Laravel\Response;
use Rhine\Repositories\CategoryRepository;
use Rhine\Repositories\ProductRepository;

class ShopGetProductAction
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
		$product = $this->productRepository->findById($id);

		if (is_null($product)) {
			return Response::error('404');
		}
		$productCategory = $this->categoryRepository->findByProduct($product);
		
		$categories = $this->categoryRepository->findAllOrdered();
		$activeCategory = null;

		return View::make('shop.product')
		->with(compact('categories'))
		->with(compact('product'))
		->with(compact('productCategory'))
		->with(compact('activeCategory'));
	}

}

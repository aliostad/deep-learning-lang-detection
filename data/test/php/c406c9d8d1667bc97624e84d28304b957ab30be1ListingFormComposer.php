<?php namespace Swapshop\Http\Composers;

use Swapshop\Product\ProductRepositoryInterface;

class ListingFormComposer
{
    /**
     * @var ProductRepositoryInterface
     */
    private $productRepository;

    /**
     * @param ProductRepositoryInterface $productRepository
     */
    public function __construct(ProductRepositoryInterface $productRepository)
    {
        $this->productRepository = $productRepository;
    }

    /**
     * @param $view
     */
    public function compose($view)
    {
        $products = $this->productRepository->getAllKeyValue();

        $view->with('products', $products);
    }
}
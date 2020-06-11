<?php

namespace malotor\shoppingcart\Application\Service;

use malotor\shoppingcart\Application\Repository\ProductRepository;
use malotor\shoppingcart\Application\Repository\BasketRepository;

class ShoppingCartService
{

    private $productRepository;
    private $basketRepository;

    public function __construct(ProductRepository $productRepository, BasketRepository  $basketRepository)
    {
        $this->productRepository = $productRepository;
        $this->basketRepository = $basketRepository;
    }

    public function addProductToBasket($productId, $baskedId)
    {
        $basket = $this->basketRepository->get($baskedId);
        $product = $this->productRepository->get($productId);
        $basket->addItem($product);
        $this->basketRepository->save($basket);
    }

    public function removeProductFromBasket($productId, $basketId)
    {
        $basket = $this->basketRepository->get($basketId);

        $basket->removeItem($productId);

        $this->basketRepository->save($basket);
    }

    public function getProductsFromBasket($basketId)
    {
        $basket = $this->basketRepository->get($basketId);
        return $basket->getItems();
    }

    public function getBasketTotalAmount($basketId)
    {
        $basket = $this->basketRepository->get($basketId);
        return $basket->totalAmount();
    }
}

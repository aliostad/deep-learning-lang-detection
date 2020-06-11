<?php

namespace BasketWithBalls\Tests\Basket;

use BasketWithBalls\Basket\Repository\BasketRepository;
use BasketWithBalls\Basket\Entity\Basket;

class BasketRepositoryTest extends \PHPUnit_Framework_TestCase
{
    const BASKET_NAME_TEST = 'test';

    public function testCreate()
    {
        $repository = new BasketRepository();

        $this->assertInstanceOf(\ArrayIterator::class, $repository->getIterator());

        return $repository;
    }

    /**
     * @depends testCreate
     */
    public function testAddBasket(BasketRepository $repository)
    {
        $basket = new Basket(self::BASKET_NAME_TEST, 10);
        $repository->addBasket($basket);

        $this->assertEquals(1, count($repository));

        return $repository;
    }

    /**
     * @depends testAddBasket
     */
    public function testGetBasket(BasketRepository $repository)
    {
        $this->assertInstanceOf(Basket::class, $repository->get(0));
    }

    /**
     * @depends testAddBasket
     */
    public function testIterator(BasketRepository $repository)
    {
        $i = 0;
        foreach ($repository as $basket) {
            $i++;
        }

        $this->assertEquals(1, $i);
    }

    /**
     * @depends testAddBasket
     */
    public function testToString(BasketRepository $repository)
    {
        $this->assertTrue(strpos(self::BASKET_NAME_TEST, (string)$repository) !== false);
    }
}

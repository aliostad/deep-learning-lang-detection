<?php
/**
 * Created by PhpStorm.
 * User: abu
 * Date: 15/5/25
 * Time: 下午5:53
 */
namespace Facade;

class FundBModel
{
    function buy()
    {
        $stockA = new \Facade\StockAModel();
        $stockA->buy();

        $stockB = new \Facade\StockBModel();
        $stockB->buy();

        $stockC = new \Facade\StockCModel();
        $stockC->buy();
    }


    function sell()
    {
        $stockA = new \Facade\StockAModel();
        $stockA->sell();

        $stockB = new \Facade\StockBModel();
        $stockB->sell();

        $stockC = new \Facade\StockCModel();
        $stockC->sell();
    }
}
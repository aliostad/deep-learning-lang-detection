<?php
/**
 * Helper service for DdxDr
 * @author Allan
 */
namespace Ddx\Dr\ReaderBundle\Service;
use Ddx\Dr\ReaderBundle\Service\AbstractDdxDrService;

use Doctrine\ORM\EntityManagerInterface;
use Ddx\Dr\MarketBundle\Service\TradeService;
use Ddx\Dr\MarketBundle\Service\TradingPairService;
use Ddx\Dr\ReaderBundle\Service\KrakenMarketService;

class BaseHelper extends AbstractDdxDrService{
    
    /**
     * @param EntityManagerInterface $entityManager
     * @param TradeService $tradeService
     * @param TradingPairService $tradingPairService
     * @param KrakenMarketService $krakenMarketService
     * @return \Ddx\Dr\ReaderBundle\Service\BaseHelper
     */
    public function __construct(
            EntityManagerInterface $entityManager,
            TradeService $tradeService,
            TradingPairService $tradingPairService,
            KrakenMarketService $krakenMarketService
            ) {
        
        $this
                ->setEntityManager($entityManager)
                ->setTradeService($tradeService)
                ->setTradingPairService($tradingPairService)
                ->setKrakenMarketService($krakenMarketService)
                ;
        return $this;
    }
    
}

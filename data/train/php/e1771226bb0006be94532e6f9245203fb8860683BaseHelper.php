<?php
/**
 * Helper service for DdxDr
 * @author Allan
 */

namespace Dr\ReaderBundle\Service;


use Doctrine\ORM\EntityManagerInterface;
use Dr\MarketBundle\Service\TradeService;
use Dr\MarketBundle\Service\TradingPairService;
use Dr\ReaderBundle\Service\KrakenMarketService;
use Dr\StrategyBundle\Service\FilterService;

class BaseHelper extends AbstractDdxDrService{


    /**
     * BaseHelper constructor.
     *
     * @param EntityManagerInterface                       $entityManager
     * @param TradeService                                 $tradeService
     * @param TradingPairService                           $tradingPairService
     * @param \Dr\ReaderBundle\Service\KrakenMarketService $krakenMarketService
     * @param FilterService                                $filterService
     */
    public function __construct(
            EntityManagerInterface $entityManager,
            TradeService $tradeService,
            TradingPairService $tradingPairService,
            KrakenMarketService $krakenMarketService,
            FilterService $filterService
            ) {
        
        $this
            ->setEntityManager($entityManager)
            ->setTradeService($tradeService)
            ->setTradingPairService($tradingPairService)
            ->setKrakenMarketService($krakenMarketService)
            ->setFilterService($filterService)
        ;

    }
    
}

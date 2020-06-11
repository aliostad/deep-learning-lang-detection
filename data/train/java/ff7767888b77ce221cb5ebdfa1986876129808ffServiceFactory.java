package com.tintuna.stockfx.application;

import com.tintuna.stockfx.service.PCollectionService;
import com.tintuna.stockfx.service.PortfolioService;
import com.tintuna.stockfx.service.PortfolioTypeService;
import com.tintuna.stockfx.service.PortfolioStockService;
import com.tintuna.stockfx.service.StockService;

public class ServiceFactory {
	private PortfolioService portfolioService;
	private PortfolioStockService portfoliostockService;
	private StockService stockService;
	private PCollectionService collectionService;

	public PCollectionService getCollectionService() {
		if (collectionService == null) {
			collectionService = new PCollectionService();
		}
		return collectionService;
	}
	
	public PortfolioService getPortfolioService() {
		if (portfolioService == null) {
			portfolioService = new PortfolioService();
		}
		return portfolioService;
	}
	
	public StockService getStockService() {
		if (stockService == null) {
			stockService = new StockService();
		}
		return stockService;
	}
	
	public PortfolioStockService getPortfoliostockService() {
		if (portfoliostockService == null) {
			portfoliostockService = new PortfolioStockService();
		}
		return portfoliostockService;
	}
}

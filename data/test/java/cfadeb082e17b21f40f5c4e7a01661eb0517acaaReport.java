package bankofjava.service;

import java.util.List;

import bankofjava.domain.Stock;
import bankofjava.infra.database.AccountRepository;
import bankofjava.infra.database.StockRepository;
import bankofjava.infra.database.TransactionRepository;

public class Report {
	private final AccountRepository accountRepository;
	private final StockRepository stockRepository;
	private final TransactionRepository transactionRepository;
	
	public Report(AccountRepository accountRepository, StockRepository stockRepository, TransactionRepository transactionRepository){
		this.accountRepository = accountRepository;
		this.stockRepository = stockRepository;
		this.transactionRepository = transactionRepository;
	}
	/*
	public List<Stock> getTopMarkers(){
		return stockRepository.getFallers(3).addAll(stockRepository.getRisers(3));
	}

	public getTopAccount(){
		
	}

	public getMostBuyedStock(){
		
	}

	public getMostSelledStock(){
		
	}*/

}

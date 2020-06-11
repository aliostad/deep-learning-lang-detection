package devopsdistilled.operp.server.context.stock;

import javax.inject.Inject;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.remoting.rmi.RmiServiceExporter;

import devopsdistilled.operp.server.data.service.stock.StockKeeperService;
import devopsdistilled.operp.server.data.service.stock.StockService;
import devopsdistilled.operp.server.data.service.stock.WarehouseService;

@Configuration
public class StockRmiContext {

	@Inject
	private StockService stockService;

	@Inject
	private WarehouseService warehouseService;

	@Inject
	private StockKeeperService stockKeeperService;

	@Bean
	public RmiServiceExporter rmiStockServiceExporter() {
		RmiServiceExporter rmiServiceExportor = new RmiServiceExporter();
		rmiServiceExportor.setServiceName("StockService");
		rmiServiceExportor.setServiceInterface(StockService.class);
		rmiServiceExportor.setService(stockService);
		rmiServiceExportor.setRegistryPort(1099);
		return rmiServiceExportor;

	}

	@Bean
	public RmiServiceExporter rmiWarehouseServiceExporter() {
		RmiServiceExporter rmiServiceExporter = new RmiServiceExporter();
		rmiServiceExporter.setServiceName("WarehouseService");
		rmiServiceExporter.setServiceInterface(WarehouseService.class);
		rmiServiceExporter.setService(warehouseService);
		return rmiServiceExporter;
	}

	@Bean
	public RmiServiceExporter rmiStockKeeperServiceExporter() {
		RmiServiceExporter rmiServiceExporter = new RmiServiceExporter();
		rmiServiceExporter.setServiceName("StockKeeperService");
		rmiServiceExporter.setServiceInterface(StockKeeperService.class);
		rmiServiceExporter.setService(stockKeeperService);
		return rmiServiceExporter;
	}

}

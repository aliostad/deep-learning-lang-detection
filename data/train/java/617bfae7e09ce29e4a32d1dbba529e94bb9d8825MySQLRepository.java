package mysql;

import order.OrderRepository;
import saga.OrderSagaRepository;
import shipping.ShippingRepository;
import stock.StockRepository;
import bda.Repository;

public class MySQLRepository implements Repository {

	private MySQLConnectionPool connectionPool;

	public MySQLRepository() {
		this.connectionPool = new MySQLConnectionPool();
	}

	@Override
	public OrderSagaRepository orderSagaRepository() {
		return new MySQLOrderSagaRepository(connectionPool);
	}

	@Override
	public OrderRepository orderRepository() {
		return new MySQLOrderRepository(connectionPool);
	}

	@Override
	public ShippingRepository shippingRepository() {
		return new MySQLShippingRepository(connectionPool);
	}

	@Override
	public StockRepository stockRepository() {
		return new MySQLStockRepository(connectionPool);
	}

}

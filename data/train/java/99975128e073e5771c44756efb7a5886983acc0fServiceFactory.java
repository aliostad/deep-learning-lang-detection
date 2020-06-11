package bookshop.service.factory;

import bookshop.service.BookService;
import bookshop.service.InventoryService;
import bookshop.service.OrderService;
import bookshop.service.UserService;
import bookshop.service.impl.BookServiceImpl;
import bookshop.service.impl.InventoryServiceImpl;
import bookshop.service.impl.OrderServiceImpl;
import bookshop.service.impl.UserServiceImpl;

public class ServiceFactory {
	private BookService bookService = new BookServiceImpl();
	private InventoryService inventoryService = new InventoryServiceImpl();
	private OrderService orderService = new OrderServiceImpl();
	private UserService userService = new UserServiceImpl();

	private static ServiceFactory instance = null;

	private ServiceFactory() {

	}

	public static ServiceFactory getInstance() {
		if (instance == null) {
			instance = new ServiceFactory();
		}
		return instance;
	}

	public BookService getBookService() {
		return bookService;
	}

	public InventoryService getInventoryService() {
		return inventoryService;
	}

	public OrderService getOrderService() {
		return orderService;
	}

	public UserService getUserService() {
		return userService;
	}

}

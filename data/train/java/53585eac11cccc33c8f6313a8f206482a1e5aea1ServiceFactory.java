package rj.util;

import rj.service.CategoryService;
import rj.service.ContactInfoService;
import rj.service.OrderLineService;
import rj.service.OrderService;
import rj.service.OrderStatusService;
import rj.service.PayWayService;
import rj.service.ProductService;
import rj.service.UserService;
import rj.service.impl.CategoryServerImpl;
import rj.service.impl.ContactInfoServiceImpl;
import rj.service.impl.OrderLineServiceImpl;
import rj.service.impl.OrderServiceImpl;
import rj.service.impl.OrderStatusServiceImpl;
import rj.service.impl.PayWayServiceImpl;
import rj.service.impl.ProductServiceImpl;
import rj.service.impl.UserServiceImpl;

public class ServiceFactory {

	private static UserService userService = new UserServiceImpl();
	private static OrderStatusService orderStatusService = new OrderStatusServiceImpl();
	private static OrderService ordersService = new OrderServiceImpl();
	private static OrderLineService orderLineService = new OrderLineServiceImpl();
	private static PayWayService paywayService = new PayWayServiceImpl();
	private static CategoryService categoryService = new CategoryServerImpl();
	private static ProductService productService = new ProductServiceImpl();
	private static ContactInfoService contactInfoService = new ContactInfoServiceImpl();

	public static ContactInfoService getContactInfoService() {
		return contactInfoService;
	}
	
	public static ProductService  getProductService() {
		return productService;
	}
	
	public static CategoryService getcategoryService() {
		return categoryService;
	}
	
	public static PayWayService getPaywayService() {
		return paywayService;
	}

	public static OrderLineService getOrderLineService() {
		return orderLineService;
	}

	public static UserService getUserService() {
		return userService;
	}

	public static OrderStatusService getOrderStatusService() {
		return orderStatusService;
	}

	public static OrderService getOrderService() {
		return ordersService;
	}

}

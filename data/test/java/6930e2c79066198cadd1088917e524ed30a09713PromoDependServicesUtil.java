package com.cartmatic.estore.sales.util;

import com.cartmatic.estore.common.service.OrderService;
import com.cartmatic.estore.common.service.ProductService;

public class PromoDependServicesUtil {
	private static ProductService productService;
	
	private static OrderService orderService;

	public static ProductService getProductService() {
		return productService;
	}

	public static void setProductService(ProductService _productService) {
		productService = _productService;
	}

	public static OrderService getOrderService() {
		return orderService;
	}

	public static void setOrderService(OrderService _orderService) {
		orderService = _orderService;
	}
	
}

package cn.com.tarena.service.impl;

import java.util.List;

import cn.com.tarena.service.OrderService;
import cn.com.tarena.service.OrderlineproductService;
import cn.com.tarena.service.ProductService;
import cn.com.tarena.service.ReciverService;
import cn.com.tarena.service.UserService;

public class ServiceFactory {

	public static OrderService getOrderList() {
		// TODO Auto-generated method stub
		OrderService orderService = new OrderServiceImpl();
		
		return orderService;
	}
	public static ProductService getProductList() {
		// TODO Auto-generated method stub
		ProductService productService = new ProductServiceImpl();
		
		return productService;
	}
	
	public static ReciverService getreciverList() {
		// TODO Auto-generated method stub
		ReciverService reciverService = new ReciverServiceImpl();
		
		return reciverService;
	}
	
	public static OrderlineproductService getorderlineList() {
		// TODO Auto-generated method stub
		OrderlineproductService orderlineService = new OrderlineServiceImpl();
		
		return orderlineService;
	}
	
	public static UserService getuserList() {
		// TODO Auto-generated method stub
		UserService userinfoService = new UserServiceImpl();
		
		return userinfoService;
	}
	

}

package com.softeem.jingdong.factory;

import com.softeem.jingdong.service.GoodsService;
import com.softeem.jingdong.service.OrderService;
import com.softeem.jingdong.service.ShoppingCarService;
import com.softeem.jingdong.service.UsersService;
import com.softeem.jingdong.service.impl.GoodsServiceImpl;
import com.softeem.jingdong.service.impl.OrderServiceImpl;
import com.softeem.jingdong.service.impl.ShoppingCarServiceImpl;
import com.softeem.jingdong.service.impl.UsersServiceImpl;

public class ServiceFactory {
	
	//获取 UsersService 实例
	public static UsersService getUsersServiceInstance(){
		return new UsersServiceImpl();
	}
	
	//获取 GoodsService 实例
	public static GoodsService getGoodsServiceInstance(){
		return new GoodsServiceImpl();
	}
	
	//获取 ShoppingCarService 实例
	public static ShoppingCarService getShoppingCarServiceInstance(){
		return new ShoppingCarServiceImpl();
	}
	
	//获取 OrderService 实例
	public static OrderService getOrderServiceInstance(){
		return new OrderServiceImpl();
	}

}

package com.shopping.factory;

import com.shopping.service.AdminService;
import com.shopping.service.CardService;
import com.shopping.service.CartService;
import com.shopping.service.CategoryService;
import com.shopping.service.ContactService;
import com.shopping.service.ItemService;
import com.shopping.service.MyOrderService;
import com.shopping.service.OrderInfoService;
import com.shopping.service.ProductService;
import com.shopping.service.UserService;
import com.shopping.service.impl.AdminServiceImpl;
import com.shopping.service.impl.CardServiceImpl;
import com.shopping.service.impl.CartServiceImpl;
import com.shopping.service.impl.CategoryServiceImpl;
import com.shopping.service.impl.ContactServiceImpl;
import com.shopping.service.impl.ItemServiceImpl;
import com.shopping.service.impl.MyOrderServiceImpl;
import com.shopping.service.impl.OrderInfoServiceImpl;
import com.shopping.service.impl.ProductServiceImpl;
import com.shopping.service.impl.UserServiceImpl;

public class ServiceFactory {

	/**
	 * 取得UserService接口的实例
	 * 
	 * @return UserService 实例
	 */
	public static UserService getUserServiceInstance() {
		return new UserServiceImpl();
	}

	/**
	 * 取得CategoryService接口的实例
	 * 
	 * @return
	 */
	public static CategoryService getCategoryServiceInstance() {
		return new CategoryServiceImpl();
	}

	/**
	 * 取得ItemService接口实例
	 * 
	 * @return
	 */
	public static ItemService getItemServiceInstance() {
		return new ItemServiceImpl();
	}

	/**
	 * 取得ProductService接口实例
	 * 
	 * @return
	 */
	public static ProductService getProductServiceInstance() {
		return new ProductServiceImpl();
	}

	/**
	 * 取得CartService接口实例
	 * 
	 * @return
	 */
	public static CartService getCartServiceInstance() {
		return new CartServiceImpl();
	}

	/**
	 * 取得OrderService接口实例
	 * 
	 * @return
	 */
	public static MyOrderService getOrderServiceInstance() {
		return new MyOrderServiceImpl();
	}

	/**
	 * 取得ContactService接口实例
	 * 
	 * @return
	 */
	public static ContactService getContactServiceInstance() {
		return new ContactServiceImpl();
	}

	/**
	 * 取得OrderInfoService接口实例
	 * 
	 * @return
	 */
	public static OrderInfoService getOrderInfoServiceInstance() {
		return new OrderInfoServiceImpl();
	}

	/**
	 * 取得CardService接口实例
	 * 
	 * @return
	 */
	public static CardService getCardServiceInstance() {
		return new CardServiceImpl();
	}

	/**
	 * 取得AdminService接口的实例
	 * 
	 * @return
	 */
	public static AdminService getAdminServiceInstance() {
		return new AdminServiceImpl();
	}
}

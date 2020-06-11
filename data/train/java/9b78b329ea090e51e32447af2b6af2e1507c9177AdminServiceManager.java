package dg.app.service;

import dg.app.service.admin.OrderService;
import dg.app.service.admin.UserService;

/**
 * 后台管理Service管理器
 * 
 * @author Nanlei
 * 
 */
public class AdminServiceManager {
	// Spring中注入名为admin*Service，为了和前台区分开
	private UserService adminUserService;
	private OrderService adminOrderService;

	public UserService getAdminUserService() {
		return adminUserService;
	}

	public void setAdminUserService(UserService adminUserService) {
		this.adminUserService = adminUserService;
	}

	public OrderService getAdminOrderService() {
		return adminOrderService;
	}

	public void setAdminOrderService(OrderService adminOrderService) {
		this.adminOrderService = adminOrderService;
	}

}

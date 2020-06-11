package service;

import java.util.List;

import bean.Orders;
import bean.User;
import dao.OrdersDao;

public class OrdersManage {
	private OrdersDao ordersDao;
	private GoodsManage goodsManage;
	private UserManageImp userManage;
	private SaveManage saveManage;
	
	

	public SaveManage getSaveManage() {
		return saveManage;
	}



	public void setSaveManage(SaveManage saveManage) {
		this.saveManage = saveManage;
	}



	public GoodsManage getGoodsManage() {
		return goodsManage;
	}



	public void setGoodsManage(GoodsManage goodsManage) {
		this.goodsManage = goodsManage;
	}



	public UserManageImp getUserManage() {
		return userManage;
	}



	public void setUserManage(UserManageImp userManage) {
		this.userManage = userManage;
	}



	public OrdersDao getOrdersDao() {
		return ordersDao;
	}



	public void setOrdersDao(OrdersDao ordersDao) {
		this.ordersDao = ordersDao;
	}



	public List<Orders> showAllOrders() {
		// TODO Auto-generated method stub
		System.out.println("------show orders");
		return ordersDao.showAllOrders();
	}



	public void AddOrders(Orders goods) {
		// TODO Auto-generated method stub	
		int money = goods.getGood().getPrice();
		User user = goods.getUser();
		user.setMoney(user.getMoney()-money);
		user.setScope(user.getScope()+10);
		this.userManage.modifyUser(user);
		ordersDao.AddOrders(goods);
	}



	public void modifyOrders(Orders goods) {
		// TODO Auto-generated method stub
		ordersDao.modifyOrders(goods);
	}



	public void deleteOrders(Orders goods) {
		// TODO Auto-generated method stub
		ordersDao.deleteOrders(goods);
	}



	public Orders getOrders(int id) {
		// TODO Auto-generated method stub
		return ordersDao.getOrders(id);
	}
	public List<Orders> getAllOrders(User user) {
		return ordersDao.getAllOrders(user);
	}
	public List<Orders> queryByPage(int pageSize, int pageNow) {
		// TODO Auto-generated method stub
		return ordersDao.queryByPage(pageSize, pageNow);
	}

}

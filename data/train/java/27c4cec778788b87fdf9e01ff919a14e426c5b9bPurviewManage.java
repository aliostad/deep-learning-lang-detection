package com.insigma.pojo;

/**
 * 权限管理信息
 * 属性：唯一标识、权限编号、雇员管理、订单管理、类别管理、菜品管理
 * @author Icker
 *
 */
public class PurviewManage {
	private int id;
	private int purviewId;
	private int employeManage;
	private int orderManage;
	private int sortManage;
	private int dishManage;
	
	public PurviewManage() {
		super();
	}
	
	public PurviewManage(int purviewId, int employeManage, int orderManage,
			int sortManage, int dishManage) {
		super();
		this.purviewId = purviewId;
		this.employeManage = employeManage;
		this.orderManage = orderManage;
		this.sortManage = sortManage;
		this.dishManage = dishManage;
	}
	
	public PurviewManage(int id, int purviewId, int employeManage, int orderManage,
			int sortManage, int dishManage) {
		super();
		this.id = id;
		this.purviewId = purviewId;
		this.employeManage = employeManage;
		this.orderManage = orderManage;
		this.sortManage = sortManage;
		this.dishManage = dishManage;
	}

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public int getPurviewId() {
		return purviewId;
	}

	public void setPurviewId(int purviewId) {
		this.purviewId = purviewId;
	}

	public int getEmployeManage() {
		return employeManage;
	}

	public void setEmployeManage(int employeManage) {
		this.employeManage = employeManage;
	}

	public int getOrderManage() {
		return orderManage;
	}

	public void setOrderManage(int orderManage) {
		this.orderManage = orderManage;
	}

	public int getSortManage() {
		return sortManage;
	}

	public void setSortManage(int sortManage) {
		this.sortManage = sortManage;
	}

	public int getDishManage() {
		return dishManage;
	}

	public void setDishManage(int dishManage) {
		this.dishManage = dishManage;
	}
	
	
}

package com;

/**
 * Purviewmanage entity. @author MyEclipse Persistence Tools
 */

public class Purviewmanage implements java.io.Serializable {

	// Fields

	private Integer id;
	private Integer purviewId;
	private Integer employeManage;
	private Integer orderManage;
	private Integer sortManage;
	private Integer dishManage;

	// Constructors

	/** default constructor */
	public Purviewmanage() {
	}

	/** minimal constructor */
	public Purviewmanage(Integer purviewId) {
		this.purviewId = purviewId;
	}

	/** full constructor */
	public Purviewmanage(Integer purviewId, Integer employeManage,
			Integer orderManage, Integer sortManage, Integer dishManage) {
		this.purviewId = purviewId;
		this.employeManage = employeManage;
		this.orderManage = orderManage;
		this.sortManage = sortManage;
		this.dishManage = dishManage;
	}

	// Property accessors

	public Integer getId() {
		return this.id;
	}

	public void setId(Integer id) {
		this.id = id;
	}

	public Integer getPurviewId() {
		return this.purviewId;
	}

	public void setPurviewId(Integer purviewId) {
		this.purviewId = purviewId;
	}

	public Integer getEmployeManage() {
		return this.employeManage;
	}

	public void setEmployeManage(Integer employeManage) {
		this.employeManage = employeManage;
	}

	public Integer getOrderManage() {
		return this.orderManage;
	}

	public void setOrderManage(Integer orderManage) {
		this.orderManage = orderManage;
	}

	public Integer getSortManage() {
		return this.sortManage;
	}

	public void setSortManage(Integer sortManage) {
		this.sortManage = sortManage;
	}

	public Integer getDishManage() {
		return this.dishManage;
	}

	public void setDishManage(Integer dishManage) {
		this.dishManage = dishManage;
	}

}
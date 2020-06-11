package com.usermanage.vo;

public class ManagerVo {
	private int id;
	private String manage_name;
	private String manage_pass;
	private String create_date;
	private String manage_role;
	/**
	 * @return the id
	 */
	public int getId() {
		return id;
	}
	/**
	 * @param id the id to set
	 */
	public void setId(int id) {
		this.id = id;
	}
	/**
	 * @return the manage_name
	 */
	public String getManage_name() {
		return manage_name;
	}
	/**
	 * @param manage_name the manage_name to set
	 */
	public void setManage_name(String manage_name) {
		this.manage_name = manage_name;
	}
	/**
	 * @return the manage_role
	 */
	public String getManage_role() {
		return manage_role;
	}
	/**
	 * @param manage_name the manage_name to set
	 */
	public void setManage_role(String manage_role) {
		this.manage_role = manage_role;
	}
	/**
	 * @return the manage_pass
	 */
	public String getManage_pass() {
		return manage_pass;
	}
	/**
	 * @param manage_pass the manage_pass to set
	 */
	public void setManage_pass(String manage_pass) {
		this.manage_pass = manage_pass;
	}
	/**
	 * @return the create_date
	 */
	public String getCreate_date() {
		return create_date;
	}
	/**
	 * @param create_date the create_date to set
	 */
	public void setCreate_date(String create_date) {
		this.create_date = create_date;
	}

}

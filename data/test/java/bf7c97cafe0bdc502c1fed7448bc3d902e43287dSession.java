package com.rescam.xhb.framework.pojo;

import com.rescam.xhb.framework.entity.ManageUser;

public class Session {
	private ManageUser manageUser;
	private Integer customerId;
	private String weixinOpenId;
	public ManageUser getManageUser() {
		return manageUser;
	}
	public void setManageUser(ManageUser manageUser) {
		this.manageUser = manageUser;
	}
	public Integer getCustomerId() {
		return customerId;
	}
	public void setCustomerId(Integer customerId) {
		this.customerId = customerId;
	}
	public String getWeixinOpenId() {
		return weixinOpenId;
	}
	public void setWeixinOpenId(String weixinOpenId) {
		this.weixinOpenId = weixinOpenId;
	}
	
	
}

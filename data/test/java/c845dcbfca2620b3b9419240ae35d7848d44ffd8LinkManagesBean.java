package com.cn.leedane.model;

import java.io.Serializable;
import java.util.List;


/**
 * 链接权限管理实体bean
 * @author LeeDane
 * 2017年4月10日 下午5:21:37
 * version 1.0
 */
public class LinkManagesBean implements Serializable{
	
	private static final long serialVersionUID = 1L;
    
	private List<LinkManageBean> linkManageBean;

	public List<LinkManageBean> getLinkManageBean() {
		return linkManageBean;
	}

	public void setLinkManageBean(List<LinkManageBean> linkManageBean) {
		this.linkManageBean = linkManageBean;
	}
}

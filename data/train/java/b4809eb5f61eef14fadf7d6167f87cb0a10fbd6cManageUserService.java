package com.rescam.xhb.framework.service;

import java.util.List;

import org.hibernate.HibernateException;

import com.rescam.xhb.common.service.BasicService;
import com.rescam.xhb.framework.entity.ManageUser;

public interface ManageUserService extends BasicService<ManageUser> {

	/**
	 * 后台登录
	 * @return
	 */
	public List<ManageUser> userlogin(ManageUser user);
	/**
	 * 后台用户总数
	 * @return
	 */
	public int getAllManageUserTotal(ManageUser user);
	/**
	 * 加载后台用户
	 * @param user
	 * @return
	 */
	public List<ManageUser> getAllManageUser(ManageUser user,int page);
	/**
	 * 新增后台用户
	 * @return
	 */
	@SuppressWarnings("rawtypes")
	public int addManageUser(ManageUser user);
}


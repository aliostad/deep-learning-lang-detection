package com.rescam.xhb.framework.dao;

import java.util.List;

import com.rescam.xhb.common.dao.BasicDao;
import com.rescam.xhb.framework.entity.ManageUser;

public interface ManageUserDao extends BasicDao<ManageUser> {

	/**
	 * 后台登录
	 * @return
	 */
	public List<ManageUser> userlogin(ManageUser user);
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
	
	/**
	 * 后台用户总数
	 * @return
	 */
	public int getAllManageUserTotal(ManageUser user);

}

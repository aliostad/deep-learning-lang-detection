package com.ggy.baby.userManage.service;

import com.ggy.baby.userManage.pageModel.UserManageIn;
import com.ggy.baby.userManage.pageModel.UserManageOut;

/**
 * 用户管理service接口
 * @author Chencong
 *
 */
public interface IUserManageService {
	/**
	 * 初始化用户管理页面
	 * @author Chencong
	 * @param in
	 * @return
	 */
	UserManageOut initUserManage(UserManageIn in);
	/**
	 * 查询用户集合
	 * @author Chencong
	 * @param in
	 * @return
	 */
	UserManageOut findUsers(UserManageIn in);
	/**
	 * 生成用户
	 * @author Chencong
	 * @param in
	 * @return
	 */
	UserManageOut generateUsers(UserManageIn in);
	/**
	 * 用户信息 幼儿园管理
	 * @author Chencong
	 * @param in
	 * @return
	 */
	UserManageOut usersInfo(UserManageIn in);
	/**
	 * 进入生成用户页面
	 * @author Chencong
	 * @param in
	 * @return
	 */
	UserManageOut initGenerateUsers(UserManageIn in);
	/**
	 * 删除用户
	 * @author Chencong
	 * @param in
	 * @return
	 */
	UserManageOut deleteUser(UserManageIn in);
	/**
	 * 更新用户
	 * @author Chencong
	 * @param in
	 * @return
	 */
	UserManageOut updateUser(UserManageIn in);
	/**
	 * 导出用户
	 * @author Chencong
	 * @param in
	 * @return
	 */
	UserManageOut exportUser(UserManageIn in);
	/**
	 * 批量删除用户
	 * @author Chencong
	 * @param in
	 * @return
	 */
	UserManageOut batchDeleteUser(UserManageIn in);
	/**
	 * 保存用户
	 * @author Chencong
	 * @param in
	 * @return
	 */
	UserManageOut saveUsers(UserManageIn in);
	
}

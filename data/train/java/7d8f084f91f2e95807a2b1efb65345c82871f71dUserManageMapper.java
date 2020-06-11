/**
* Copyright ? 2014-1-9 liuninglin
* WorkingTimeRecordSystem 上午12:22:24
* Version 1.0
* All right reserved.
*
*/

package com.mapper;

import org.apache.ibatis.annotations.Param;

import com.entity.UserManage;

/**
 * 类描述： 
 * 创建者：刘宁林
 * 项目名称： WorkingTimeRecordSystem
 * 创建时间： 2014-1-9 上午12:22:24
 * 版本号： v1.0
 */
public interface UserManageMapper extends SqlMapper
{
	public UserManage checkUserManageIsExist(@Param("username")String username, @Param("password")String password);
	
	public void addUserManage(UserManage userManage);
    
    public void editUserManage(UserManage userManage);
    
    public void removeUserManage(int userid);
}

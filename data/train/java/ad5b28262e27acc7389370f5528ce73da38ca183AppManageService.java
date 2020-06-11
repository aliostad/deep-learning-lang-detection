package com.wt.hea.appmanage.service;

import java.io.Serializable;
import java.util.List;

import com.wt.hea.appmanage.model.AppManage;
import com.wt.hea.common.model.Page;

/**
 * <pre>
 * 业务名:
 * 功能说明: 
 * 编写日期:	2011-8-26
 * 作者:	xiaoqi
 * 
 * 历史记录
 * 1、修改日期：
 *    修改人：
 *    修改内容：
 * </pre>
 */
public interface AppManageService
{
	/**
	 * 方法说明： 
	 * 
	 * @param e 
	 */
	public void delete(AppManage e);

	/**
	 * 方法说明： 
	 * 
	 * @param id 
	 */
	public void deleteById(Serializable id);

	/**
	 * 方法说明：  
	 * 
	 * @param id 
	 * @return AppManage
	 */
	public AppManage findById(Serializable id);

	/**
	 * 方法说明： 
	 * 
	 * @param property 
	 * @param value 
	 * @return List<AppManage>
	 */
	public List<AppManage> findByProperty(String property, Object value);

	/**
	 * 方法说明： 
	 * 
	 * @param pageModel 
	 * @return Page<AppManage>
	 */
	public Page<AppManage> loadPage(Page<AppManage> pageModel);

	/**
	 * 方法说明： 
	 * 
	 * @param e 
	 */
	public void save(AppManage e);

	/**
	 * 方法说明： 
	 * 
	 * @param e 
	 * @return AppManage
	 */
	public AppManage update(AppManage e);

	/**
	 * 方法说明：模糊查询appManage对象中属性值不为NULL的appManage信息
	 * 
	 * @param obj
	 *            appManage对象
	 * @return appManage列表
	 */
	public List<AppManage> findByExample(AppManage obj);
}

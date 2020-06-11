package com.wt.hea.appmanage.struts.action;

import com.wt.hea.appmanage.service.AppManageService;
import com.wt.hea.common.action.DispatchAction;

/**
 * <pre>
 * 业务名:
 * 功能说明: 多应用管理模块的baseAction，注入常用的service方便引用操作
 * 编写日期:	2011-8-26
 * 作者:	xiaoqi
 * 
 * 历史记录
 * 1、修改日期：
 *    修改人：
 *    修改内容：
 * </pre>
 */
public class BaseAction extends DispatchAction
{
	/**
	 * 注入多应用管理service
	 */
	protected AppManageService appManageService;

	public void setAppManageService(AppManageService appManageService)
	{
		this.appManageService = appManageService;
	}

}
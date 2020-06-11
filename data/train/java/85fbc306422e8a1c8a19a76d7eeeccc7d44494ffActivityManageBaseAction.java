/**
 * Copyright @ 2011 Beijing 北京佳信汇通科技有限公司.
 * All right reserved.
 */

package com.juicy.signature.action.base;

import com.juicy.signature.service.ActivityManage;
import com.opensymphony.xwork2.ActionSupport;

/**
 * 活动管理基本Action
 *
 * @author 路卫杰
 * @version <p>Nov 21, 2011 创建</p>
 */
public class ActivityManageBaseAction extends ActionSupport {

	/** serialVersionUID */
	private static final long serialVersionUID = 1L;
	
	/** ActivityManage */
	protected ActivityManage activityManage;

	public ActivityManage getActivityManage() {
		return activityManage;
	}

	public void setActivityManage(ActivityManage activityManage) {
		this.activityManage = activityManage;
	}
	

}

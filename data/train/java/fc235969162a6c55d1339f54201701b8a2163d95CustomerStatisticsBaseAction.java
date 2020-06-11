/**
 * Copyright @ 2011 Beijing 北京佳信汇通科技有限公司.
 * All right reserved.
 */

package com.juicy.signature.action.base;

import com.juicy.signature.service.StatisticsManage;
import com.opensymphony.xwork2.ActionSupport;

/**
 * 用户统计基本Action
 *
 * @author 路卫杰
 * @version <p>Nov 24, 2011 创建</p>
 */
public class CustomerStatisticsBaseAction extends ActionSupport {

	/** serialVersionUID */
	private static final long serialVersionUID = 1L;
	
	protected StatisticsManage statisticsManage;
	
	/** 操作后的信息 */
	private String message;

	public StatisticsManage getStatisticsManage() {
		return statisticsManage;
	}

	public void setStatisticsManage(StatisticsManage statisticsManage) {
		this.statisticsManage = statisticsManage;
	}

	public String getMessage() {
		return message;
	}

	public void setMessage(String message) {
		this.message = message;
	}
	
	

}

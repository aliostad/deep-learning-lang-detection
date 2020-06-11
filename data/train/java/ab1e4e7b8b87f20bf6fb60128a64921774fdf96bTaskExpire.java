package com.soarsky.octopus.schedule;

import com.soarsky.octopus.task.service.TTaskService;

/**
 * 任务过期处理类
 * @author chenll
 *
 */
public class TaskExpire {
	
	private TTaskService tTaskService;
	
	/**
	 * 更新任务的过期标示
	 */
	public void updateExpireState(){
		tTaskService.updateExpire();
	}

	public TTaskService gettTaskService() {
		return tTaskService;
	}

	public void settTaskService(TTaskService tTaskService) {
		this.tTaskService = tTaskService;
	}
	

	

}

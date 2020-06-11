package com.zhuoxuan.role.workflow.entity;

import java.io.Serializable;

import org.activiti.engine.identity.User;
import org.activiti.engine.repository.ProcessDefinition;
import org.activiti.engine.runtime.ProcessInstance;
import org.activiti.engine.task.Task;

/**
 * 
 * <p>
 *  任务信息
 * </p>
 * 
 * @author 卓轩
 * @创建时间：2014年8月16日
 * @version： V1.0
 */
public class UserTask implements Serializable{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;


	/**
	 * 任务申请人信息
	 */
	private User applyUser;
	
	
	/**
	 * 任务对应的当前流程实例
	 */
	private ProcessInstance processInstance;
	
	
	/**
	 * 任务对应的流程定义
	 */
	private ProcessDefinition processDefinition;
	
	
	/**
	 * 任务对应的流程引擎的Task
	 */
	private Task task;


	public User getApplyUser() {
		return applyUser;
	}


	public void setApplyUser(User applyUser) {
		this.applyUser = applyUser;
	}


	public ProcessInstance getProcessInstance() {
		return processInstance;
	}


	public void setProcessInstance(ProcessInstance processInstance) {
		this.processInstance = processInstance;
	}


	public ProcessDefinition getProcessDefinition() {
		return processDefinition;
	}


	public void setProcessDefinition(ProcessDefinition processDefinition) {
		this.processDefinition = processDefinition;
	}


	public Task getTask() {
		return task;
	}


	public void setTask(Task task) {
		this.task = task;
	}
	
	
	
	
}

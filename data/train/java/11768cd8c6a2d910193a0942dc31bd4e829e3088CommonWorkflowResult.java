package com.cabletech.business.workflow.common.model;

import com.cabletech.common.base.BaseEntity;

/**
 * 通用工单工作流处理结果实体
 * 
 * @author 杨隽 2012-01-09 创建
 * 
 */
public class CommonWorkflowResult extends BaseEntity {
	private static final long serialVersionUID = 1L;
	// 工作流处理结果
	private String processResult;
	// 工作流处理意见
	private String processComment;
	// 工作流处理人
	private String processUser;
	// 工作流处理日期
	private String processDate;

	public String getProcessResult() {
		return processResult;
	}

	public void setProcessResult(String processResult) {
		this.processResult = processResult;
	}

	public String getProcessComment() {
		return processComment;
	}

	public void setProcessComment(String processComment) {
		this.processComment = processComment;
	}

	public String getProcessUser() {
		return processUser;
	}

	public void setProcessUser(String processUser) {
		this.processUser = processUser;
	}

	public String getProcessDate() {
		return processDate;
	}

	public void setProcessDate(String processDate) {
		this.processDate = processDate;
	}
}

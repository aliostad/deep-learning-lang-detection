package com.wxl.pageStu.base.dao;

import java.io.Serializable;

public class ProcessData implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = -4755789010564187240L;
	
	private String processName;
	private String processId;
	private String createTime;
	private String processFileName;
	
	public String getProcessName() {
		return processName;
	}
	public void setProcessName(String processName) {
		this.processName = processName;
	}
	public String getProcessId() {
		return processId;
	}
	public void setProcessId(String processId) {
		this.processId = processId;
	}
	public String getCreateTime() {
		return createTime;
	}
	public void setCreateTime(String createTime) {
		this.createTime = createTime;
	}
	public String getProcessFileName() {
		return processFileName;
	}
	public void setProcessFileName(String processFileName) {
		this.processFileName = processFileName;
	}
	
	@Override
	public String toString() {
		return "ProcessData [processName=" + processName + ", processId="
				+ processId + ", createTime=" + createTime
				+ ", processFileName=" + processFileName + "]";
	}
	
}

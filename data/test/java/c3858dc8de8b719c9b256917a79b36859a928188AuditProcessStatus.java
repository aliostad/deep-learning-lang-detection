package com.esd.hesf.model;

/**
 * 审核进程状态类
 * 
 * @author Administrator
 * 
 */
public class AuditProcessStatus extends PrimaryKey_Int {
	private String auditProcessStatus;// 审核状态

	public AuditProcessStatus() {
	}

	public AuditProcessStatus(int id) {
		super.setId(id);
	}

	@Override
	public String toString() {
		return "AuditProcessStatus [auditProcessStatus=" + auditProcessStatus + ", getId()=" + getId() + "]";
	}

	public String getAuditProcessStatus() {
		return auditProcessStatus;
	}

	public void setAuditProcessStatus(String auditProcessStatus) {
		this.auditProcessStatus = auditProcessStatus;
	}

}
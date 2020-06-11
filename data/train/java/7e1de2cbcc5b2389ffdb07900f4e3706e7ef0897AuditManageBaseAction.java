/**
 * Copyright @ 2011 Beijing 北京佳信汇通科技有限公司.
 * All right reserved.
 */

package com.juicy.signature.action.base;

import com.juicy.signature.service.AuditManage;
import com.opensymphony.xwork2.ActionSupport;

/**
 * 审核管理基本Action
 *
 * @author 路卫杰
 * @version <p>Nov 23, 2011 创建</p>
 */
public class AuditManageBaseAction extends ActionSupport {

	/** serialVersionUID */
	private static final long serialVersionUID = 1L;
	
	protected AuditManage auditManage;

	public AuditManage getAuditManage() {
		return auditManage;
	}

	public void setAuditManage(AuditManage auditManage) {
		this.auditManage = auditManage;
	}
	

}

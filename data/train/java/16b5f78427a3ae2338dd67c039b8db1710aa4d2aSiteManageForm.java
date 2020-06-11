package com.wt.hea.webbuilder.struts.form;

import org.apache.struts.action.ActionForm;

import com.wt.hea.rbac.model.Index;
import com.wt.hea.webbuilder.model.SiteManage;

/**
 * 
 * <pre>
 * 业务名:
 * 功能说明: 站点管理form
 * 编写日期:	2011-3-24
 * 作者:	xiaoqi
 * 
 * 历史记录
 * 1、修改日期：
 *    修改人：
 *    修改内容：
 * </pre>
 */
@SuppressWarnings("serial")
public class SiteManageForm  extends ActionForm {
	/**
	 * 站点管理实体bean
	 */
	private SiteManage siteManage=new SiteManage();
	/**
	 * 指标bean
	 */
	private Index index=new Index();
	public SiteManage getSiteManage() {
		return siteManage;
	}

	public void setSiteManage(SiteManage siteManage) {
		this.siteManage = siteManage;
	}

	public Index getIndex() {
		return index;
	}

	public void setIndex(Index index) {
		this.index = index;
	}
}

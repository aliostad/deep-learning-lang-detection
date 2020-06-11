package com.dfire.retail.app.manage.data.bo;

import com.dfire.retail.app.manage.data.basebo.BaseRemoteBo;
import com.dfire.retail.app.manage.vo.supplyManageVo;
/**
 * 供应商添加 修改
 * @author ys
 *
 */
public class SupplyManageBo extends BaseRemoteBo{

	/**
	 * 
	 */
	private static final long serialVersionUID = 5196766920773826898L;
	/**
	 * 供应商
	 */
	private supplyManageVo supplyManageVo;
	
	public supplyManageVo getSupplyManageVo() {
		return supplyManageVo;
	}
	public void setSupplyManageVo(supplyManageVo supplyManageVo) {
		this.supplyManageVo = supplyManageVo;
	}
}


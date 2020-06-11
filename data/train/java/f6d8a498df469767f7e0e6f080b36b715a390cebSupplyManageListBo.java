package com.dfire.retail.app.manage.data.bo;

import java.util.List;

import com.dfire.retail.app.manage.data.basebo.BaseRemoteBo;
import com.dfire.retail.app.manage.vo.supplyManageVo;

/**
 * 供应商一览
 * @author ys
 *
 */
public class SupplyManageListBo extends BaseRemoteBo{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1743970861792995243L;
	
	/**
	 * 供应商列表
	 */
	private List<supplyManageVo> supplyManageList;
	/**
	 * 总页数
	 */
	private Integer pageCount;
	public List<supplyManageVo> getSupplyManageList() {
		return supplyManageList;
	}
	public void setSupplyManageList(List<supplyManageVo> supplyManageList) {
		this.supplyManageList = supplyManageList;
	}
	public Integer getPageCount() {
		return pageCount;
	}
	public void setPageCount(Integer pageCount) {
		this.pageCount = pageCount;
	}
	
}

package com.supplyplatform.action;

import com.supplyplatform.service.CommodityPropertyManageService;


/**
 * 属性类别管理
 * @author bxy
 *
 */
public class CommodityPropertyManageAction extends BaseAction {

	//商品属性管理
	private CommodityPropertyManageService commodityPropertyManageService;
	
	public void propertyType_addType() {
		
	}

	public void setCommodityPropertyManageService(
			CommodityPropertyManageService commodityPropertyManageService) {
		this.commodityPropertyManageService = commodityPropertyManageService;
	}
	
}

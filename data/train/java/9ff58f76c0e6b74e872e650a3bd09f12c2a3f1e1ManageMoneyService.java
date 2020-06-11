package com.dfc.springmvc.service;

import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

import com.dfc.springmvc.common.PageInfo;
import com.dfc.springmvc.pojo.ManageMoney;

/**
 * Êý¾Ý´¦Àí½Ó¿Ú
 * 
 * @author dongdong
 * 
 */

public interface ManageMoneyService {

	public List<ManageMoney> queryManageMoney(PageInfo<ManageMoney> pageInfo, Map<String, String> map);
	
	public List<ManageMoney> queryAllManageMoney(Map<String, Object> map);
	
	public BigDecimal getSum(Map<String, Object> map);
	
	public ManageMoney getManageMoneyById(String manageId);

	public void saveManageMoney(ManageMoney manageMoney);

	public void updateManageMoney(ManageMoney manageMoney);

	public void deleteManageMoney(String[] ids);

}

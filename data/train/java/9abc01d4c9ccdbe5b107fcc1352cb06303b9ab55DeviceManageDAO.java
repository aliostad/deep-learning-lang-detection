package com.sysware.customize.hd.investment.deviceProject.manage;


import java.util.List;

import com.sysware.customize.hd.investment.deviceProject.implementPlan.DeviceImplementplan;

public interface DeviceManageDAO {

	/**
	 * 查询实施计划数据
	 * @param vo
	 * @return
	 */
	List<DeviceImplementplan> getGridData(DeviceManageVo vo);
	
	/**
	 * 根据设备项目编号查询执行计划
	 * @param id
	 * @return
	 */
	List<DeviceImplementplan> getDeviceManageById(String id);
	
	/**
	 * 保存实施计划数据
	 * @param vo
	 * @return
	 */
	String saveManage(DeviceManageVo vo);
	
	/**
	 * 保存定向采购数据
	 * @param vo
	 * @return
	 */
	//String saveManageDirpurchase(DeviceManageDirpurchaseVo vo);
	
	/**
	 * 下发执行管理数据
	 * @param vo
	 * @return
	 */
	String sendManage(DeviceManageVo vo) throws Exception;
	
	/**
	 * 获取管理数据
	 * @param vo
	 * @return
	 */
	String getManage(DeviceManageVo vo);
	
}
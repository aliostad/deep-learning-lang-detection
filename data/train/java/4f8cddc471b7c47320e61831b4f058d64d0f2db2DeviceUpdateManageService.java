package com.threegrand.bison.deviceManage.service;

import java.util.List;

import com.threegrand.bison.deviceManage.model.DeviceUpdateManage;

public interface DeviceUpdateManageService {
	public List<DeviceUpdateManage> findDeviceListPage(DeviceUpdateManage deviceUpdateManage);
	
	public String updateDevice(DeviceUpdateManage deviceUpdateManage);
	
	public int insertDevice(DeviceUpdateManage deviceUpdateManage);

	public int updateVersion(DeviceUpdateManage deviceUpdateManage);

	public int editDevice(DeviceUpdateManage deviceUpdateManage);

	public List<DeviceUpdateManage> findHardwareVer();
	
	public DeviceUpdateManage getDeviceByUserId(String userId);
}

package com.threegrand.bison.deviceManage.dao;

import java.util.List;

import com.threegrand.bison.deviceManage.model.DeviceUpdateManage;
import com.wonderland.sail.mybatis.annotation.mybatisRepository;

@mybatisRepository
public interface DeviceUpdateManageDao {
    public List<DeviceUpdateManage> findDeviceListPage(DeviceUpdateManage deviceUpdateManage);

    public int updateDevice(DeviceUpdateManage deviceUpdateManage);

    public int insertDevice(DeviceUpdateManage deviceUpdateManage);

    public int editDevice(DeviceUpdateManage deviceUpdateManage);

    public List<DeviceUpdateManage> findHardwareVer();

    public int updateVersion(DeviceUpdateManage deviceUpdateManage);
    
    public DeviceUpdateManage getDeviceByUserId(String userid);
}

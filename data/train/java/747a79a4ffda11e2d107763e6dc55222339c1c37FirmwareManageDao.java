package com.threegrand.bison.deviceManage.dao;

import java.util.List;

import com.threegrand.bison.deviceManage.model.FirmwareManage;
import com.wonderland.sail.mybatis.annotation.mybatisRepository;

@mybatisRepository
public interface FirmwareManageDao {
    public int insert(FirmwareManage firmwareManage);

    public int edit(FirmwareManage firmwareManage);

    public int delete(Integer id);

    public List<FirmwareManage> findFirmwareListPage(FirmwareManage firmwareManage);

    public FirmwareManage getFirmwareById(Integer id);
}

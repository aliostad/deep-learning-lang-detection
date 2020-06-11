package com.threegrand.bison.deviceManage.dao;

import java.util.List;

import com.threegrand.bison.deviceManage.model.ApplicationManage;
import com.wonderland.sail.mybatis.annotation.mybatisRepository;

@mybatisRepository
public interface ApplicationManageDao {
    public int insert(ApplicationManage applicationManage);

    public int edit(ApplicationManage applicationManage);

    public int delete(Integer id);

    public List<ApplicationManage> findApplicationListPage(ApplicationManage applicationManage);

    public ApplicationManage getApplicationById(Integer id);
}

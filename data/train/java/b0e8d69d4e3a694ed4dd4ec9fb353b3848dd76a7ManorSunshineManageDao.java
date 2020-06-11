package com.xmniao.xmn.core.manor.dao;

import com.xmniao.xmn.core.base.BaseDao;
import com.xmniao.xmn.core.manor.entity.TManorSunshineManage;


public interface ManorSunshineManageDao extends BaseDao<TManorSunshineManage>{
    int deleteByPrimaryKey(Integer id);

    Integer insert(TManorSunshineManage record);

    int insertSelective(TManorSunshineManage record);

    TManorSunshineManage selectByPrimaryKey(Integer id);

    int updateByPrimaryKeySelective(TManorSunshineManage record);

    int updateByPrimaryKey(TManorSunshineManage record);
    
    public TManorSunshineManage getManorSunshineManageData(TManorSunshineManage record);
}
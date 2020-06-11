package com.xmniao.xmn.core.manor.dao;

import com.xmniao.xmn.core.base.BaseDao;
import com.xmniao.xmn.core.manor.entity.TManorHoneyManage;


public interface ManorHoneyManageDao extends BaseDao<TManorHoneyManage>{
    int deleteByPrimaryKey(Integer id);

    Integer insert(TManorHoneyManage record);

    int insertSelective(TManorHoneyManage record);

    TManorHoneyManage selectByPrimaryKey(Integer id);

    int updateByPrimaryKeySelective(TManorHoneyManage record);

    int updateByPrimaryKey(TManorHoneyManage record);
    
    TManorHoneyManage getManorHoneyManageData(TManorHoneyManage record);
}
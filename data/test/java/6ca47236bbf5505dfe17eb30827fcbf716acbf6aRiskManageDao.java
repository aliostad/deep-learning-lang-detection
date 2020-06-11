package com.wonders.stpt.project.dao;

import com.wonders.stpt.core.page.PageResultSet;
import com.wonders.stpt.project.model.RiskManage;

import java.util.List;

/**
 * Created by Administrator on 2014/6/26.
 */
public interface RiskManageDao {
    void save(List<RiskManage> riskManages) throws Exception;
    PageResultSet<RiskManage> find(RiskManage riskManage,int page,int pageSize) throws Exception;
    int deleteAll();
    /**
     * 根据id值查找记录
     * @param riskManageId
     * @return
     * @throws Exception
     */
    RiskManage load(String riskManageId)throws Exception;
    /**
     * 保存记录
     * @param riskManage
     * @return
     * @throws Exception
     */
    RiskManage save(RiskManage riskManage)throws Exception;
    /**
     * 根据主键逻辑删除记录
     * @param riskManageId
     * @return
     */
    int deletes(String riskManageId);

    List count(Integer year);

    List<RiskManage> findRisManageByDiscovery(Integer year ,int page,int pageSize);

    List<RiskManage> findByDiscovery(Integer year, int page, int pageSize);

    List<RiskManage> countByDepartment(Integer year);
}

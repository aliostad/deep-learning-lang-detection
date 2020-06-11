package com.wonders.stpt.project.service;

import com.wonders.stpt.core.page.PageResultSet;
import com.wonders.stpt.project.model.RiskManage;

import java.io.File;
import java.util.List;

/**
 * Created by Administrator on 2014/6/26.
 */
public interface RiskManageService {

    List<String> imports(File file,String user) throws Exception;
    /**
     * 保存记录
     * @param riskManage
     * @return
     * @throws Exception
     */
    RiskManage save(RiskManage riskManage) throws Exception;
    PageResultSet<RiskManage> getRiskManages(RiskManage riskManage,Integer year,int page,int pageSize) throws Exception;
    /**
     * 根据主键查找记录
     * @param riskManageId
     * @return
     * @throws Exception
     */
    RiskManage riskManage(String riskManageId)throws Exception;
    /**
     * 根据主键逻辑删除记录
     * @param riskManageId
     * @return
     */
    int deletes(String riskManageId);

    String countDataToJson(Integer year);

    List<RiskManage> getDepartmentData(Integer year);
}

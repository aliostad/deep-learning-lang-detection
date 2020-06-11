/**
* @Author: KingZhao
*          Kylin Soong
*/

package com.jcommerce.core.service.impl;

import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.hibernate.Hibernate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.jcommerce.core.dao.AutoManageDAO;
import com.jcommerce.core.model.AutoManage;
import com.jcommerce.core.service.Criteria;
import com.jcommerce.core.service.AutoManageManager;

@Service("AutoManageManager")
public class AutoManageManagerImpl extends ManagerImpl implements AutoManageManager {
    private static Log log = LogFactory.getLog(AutoManageManagerImpl.class);
    
    @Autowired
    private AutoManageDAO dao;

    public void setAutoManageDAO(AutoManageDAO dao) {
        this.dao = dao;
        super.setDao(dao);
    }

    public AutoManage initialize(AutoManage obj) {
        if (obj != null && !Hibernate.isInitialized(obj)) {
            obj = dao.getAutoManage(obj.getId());
        }
        return obj;
    }

    public List<AutoManage> getAutoManageList(int firstRow, int maxRow) {
        List list = getList(firstRow, maxRow);
        return (List<AutoManage>)list;
    }

    public int getAutoManageCount(Criteria criteria) {
        return getCount(criteria);
    }

    public List<AutoManage> getAutoManageList(Criteria criteria) {
        List list = getList(criteria);
        return (List<AutoManage>)list;
    }

    public List<AutoManage> getAutoManageList(int firstRow, int maxRow, Criteria criteria) {
        List list = getList(firstRow, maxRow, criteria);
        return (List<AutoManage>)list;
    }

    public List<AutoManage> getAutoManageList() {
        return dao.getAutoManageList();
    }

    public AutoManage getAutoManage(Long id) {
        AutoManage obj = dao.getAutoManage(id);
        return obj;
    }

    public void saveAutoManage(AutoManage obj) {
        dao.saveAutoManage(obj);
    }

    public void removeAutoManage(Long id) {
        dao.removeAutoManage(id);
    }
}

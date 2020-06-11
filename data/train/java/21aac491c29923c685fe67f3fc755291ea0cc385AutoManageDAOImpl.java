/**
* @Author: KingZhao
*/

package com.jcommerce.core.dao.impl;

import java.util.List;

import org.springframework.stereotype.Repository;

import com.jcommerce.core.dao.AutoManageDAO;
import com.jcommerce.core.model.AutoManage;

@Repository
@SuppressWarnings("unchecked")
public class AutoManageDAOImpl extends DAOImpl implements AutoManageDAO {
    public AutoManageDAOImpl() {
        modelClass = AutoManage.class;
    }

    public List<AutoManage> getAutoManageList() {
        return getList();
    }

    public AutoManage getAutoManage(Long id) {
        return (AutoManage)getById(id);
    }

    public void saveAutoManage(AutoManage obj) {
        save(obj);
    }

    public void removeAutoManage(Long id) {
        deleteById(id);
    }
}

/**
* @Author: KingZhao
*/

package com.jcommerce.core.service;

import java.util.List;

import com.jcommerce.core.model.AutoManage;
import com.jcommerce.core.service.Criteria;
public interface AutoManageManager extends Manager {
    public AutoManage initialize(AutoManage obj);

    public List<AutoManage> getAutoManageList(int firstRow, int maxRow);

    public int getAutoManageCount(Criteria criteria);

    public List<AutoManage> getAutoManageList(Criteria criteria);

    public List<AutoManage> getAutoManageList(int firstRow, int maxRow, Criteria criteria);

    public List<AutoManage> getAutoManageList();

    public AutoManage getAutoManage(Long id);

    public void saveAutoManage(AutoManage obj);

    public void removeAutoManage(Long id);
}

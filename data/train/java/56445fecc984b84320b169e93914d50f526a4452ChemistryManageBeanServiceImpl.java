package com.daren.chemistry.manage.core;

import com.daren.chemistry.manage.api.biz.IChemistryManageBeanService;
import com.daren.chemistry.manage.api.dao.IChemistryManageBeanDao;
import com.daren.chemistry.manage.entities.ChemistryManageBean;
import com.daren.core.impl.biz.GenericBizServiceImpl;

import java.util.List;

/**
 * @类描述：危险化学品业务服务实现类
 * @创建人： sunlingfeng
 * @创建时间：2014/9/9
 * @修改人：
 * @修改时间：
 * @修改备注：
 */
public class ChemistryManageBeanServiceImpl extends GenericBizServiceImpl implements IChemistryManageBeanService {
    private IChemistryManageBeanDao chemistryManageBeanDao;

    public void setChemistryManageBeanDao(IChemistryManageBeanDao chemistryManageBeanDao) {
        this.chemistryManageBeanDao = chemistryManageBeanDao;
        super.init(chemistryManageBeanDao, ChemistryManageBean.class.getName());
    }

    @Override
    public List<ChemistryManageBean> query(ChemistryManageBean bean) {
        return null;
    }

    @Override
    public List<ChemistryManageBean> getChemistryManageByLoginName(String loginName) {
        return chemistryManageBeanDao.find("select c from ChemistryManageBean c where c.loginName=?1 ", loginName);
    }
}

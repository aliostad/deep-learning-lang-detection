package com.daren.chemistry.manage.persist.openjpa;

import com.daren.chemistry.manage.api.dao.IChemistryManageBeanDao;
import com.daren.chemistry.manage.entities.ChemistryManageBean;
import com.daren.core.impl.persistence.GenericOpenJpaDao;

/**
 * @类描述：危险化学品Dao实现类
 * @创建人： sunlingfeng
 * @创建时间：2014/9/9
 * @修改人：
 * @修改时间：
 * @修改备注：
 */
public class ChemistryManageBeanDaoOpenjpa extends GenericOpenJpaDao<ChemistryManageBean, Long> implements IChemistryManageBeanDao{
}

package com.daren.chemistry.manage.api.biz;

import com.daren.chemistry.manage.entities.ChemistryManageBean;
import com.daren.core.api.biz.IBizService;

import java.util.List;

/**
 * @类描述：危险化学品业务服务接口类
 * @创建人： sunlingfeng
 * @创建时间：2014/9/9
 * @修改人：
 * @修改时间：
 * @修改备注：
 */
public interface IChemistryManageBeanService extends IBizService {
    List<ChemistryManageBean> query(ChemistryManageBean bean);

    List<ChemistryManageBean> getChemistryManageByLoginName(String loginName);
}

package com.sxit.workflow.action;


import java.util.Calendar;

import org.hibernate.HibernateException;
import com.sxit.common.action.AbstractAction;
import com.sxit.workflow.model.*;





/**
 *
 * <p>功能： 删除流程</p>
 * <p>作者： 张如兵</p>
 * <p>公司： 深圳信科</p>
 * <p>日期： 2007-10-15</p>
 * @版本： V1.0
 * @修改：
 */

public class ProcessDeleteAction extends AbstractAction {

	private TwflProcess process;

	public ProcessDeleteAction() {
           rights="wfl1,8";
	}
	public String go() throws HibernateException {
                TwflProcess process = (TwflProcess) get("process");
                getSession().delete(process);
                commit();
                message="删除成功！";
                nextpage="processList.action?pagenumber="+pagenumber;
		return SUCCESS;
	}

	public TwflProcess getProcess() {
         if (process==null)
            process = (TwflProcess) get("process");
          return process;
	}
}

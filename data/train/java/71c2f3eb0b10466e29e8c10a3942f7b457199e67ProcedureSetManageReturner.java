package com.qylm.bean.returner.procedure;

import com.qylm.bean.procedure.ProcedureSetManageBean;
import com.qylm.bean.returner.Returner;
import com.qylm.dto.procedure.ProcedureSetManageDto;
import com.qylm.entity.ProcedureSet;

public class ProcedureSetManageReturner extends Returner<ProcedureSetManageBean, ProcedureSetManageDto, ProcedureSet> {

	/**
	 * serialVersionUID
	 */
	private static final long serialVersionUID = -6345120713932815120L;

	public <T> ProcedureSetManageReturner(ProcedureSetManageDto procedureSetManageDto, Integer firstResult) {
		super(procedureSetManageDto, firstResult);
	}

	@Override
	public String returnOnly(ProcedureSetManageBean backBean) {
		return backBean.back(currentPage);
	}

}

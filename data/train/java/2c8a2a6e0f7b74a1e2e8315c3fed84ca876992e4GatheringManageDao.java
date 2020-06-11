package com.syuesoft.sell.financemanage.dao;

import java.util.List;

import com.syuesoft.bas.dao.BaseDaoI;
import com.syuesoft.bas.daoimpl.BaseDaoImpl;
import com.syuesoft.fin.vo.Datagrid;
import com.syuesoft.sell.base.dao.BaseTagDAO;
import com.syuesoft.sell.financemanage.vo.GatheringManageVo;
import com.syuesoft.sell.model.XsSellCollections;
import com.syuesoft.util.Json;

public interface GatheringManageDao extends BaseDaoI{

	
	//查询预订单信息//获取预收款信息
	public Json findBillInfor(GatheringManageVo gatheringManageVo, BaseTagDAO baseTagDAO)throws Exception;
	
	//获取预收款使用记录
	public List getUseRecord(GatheringManageVo gatheringManageVo , BaseTagDAO baseTagDAO)throws Exception;
	
	//获取应收款信息
	public Json findShouldAccountInfor(GatheringManageVo gatheringManageVo, BaseTagDAO baseTagDAO)throws Exception;
	
	//获取收款记录信息
	public Json getAmonunt(GatheringManageVo gatheringManageVo)throws Exception;
	
	//删除预收款记录
	public void deleteYamount(GatheringManageVo gatheringManageVo)throws Exception;
	
	//修改预收款记录
	public void updateYamount(GatheringManageVo gatheringManageVo)throws Exception;
	//预收款查询模块：预收款查询
	public Datagrid getReadyBillInfor(GatheringManageVo gatheringManageVo)throws Exception;
	//预收款查询模块：预收款余额查询
	public Datagrid getYuEBillInfor(GatheringManageVo gatheringManageVo)throws Exception;
	//应收款查询模块：应收款查询
	public Datagrid getShouldBillInfor(GatheringManageVo gatheringManageVo)throws Exception;
	//应收款查询模块：应收款欠额查询
	public Datagrid getQkBillInfor(GatheringManageVo gatheringManageVo)throws Exception;
	
	
}

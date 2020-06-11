package com.syuesoft.sell.sellwork.service;

import java.util.List;

import com.syuesoft.fin.vo.Datagrid;
import com.syuesoft.sell.model.XsChilddictionary;
import com.syuesoft.sell.sellwork.vo.CarSellManageVo;
import com.syuesoft.util.Json;
import com.syuesoft.util.Message;
import com.syuesoft.util.Msg;

public interface CarSellManageService {
	
	//新增销售信息
	public Boolean addSellInfor(CarSellManageVo carSellManageVo)throws Exception;
	
	//获取所有的预定单号
	public List getReserveCode(CarSellManageVo carSellManageVo)throws Exception;
	
	//通过预定单号查询 客户 车辆  财务信息
	public Json getInforById(CarSellManageVo carSellManageVo)throws Exception;
	
	//查询销售单汇总信息
	public Json findSellInfor(CarSellManageVo carSellManageVo)throws Exception;
	
	//删除销售单汇总信息
	public boolean deleteSellInfor(CarSellManageVo carSellManageVo)throws Exception;
	
	//修改销售单汇总信息
	public Boolean updateSellInfor(CarSellManageVo carSellManageVo)throws Exception;
	
	//审核销售单信息
	public Message doAuditSellInfor(CarSellManageVo carSellManageVo)throws Exception;
	
	//获取PDI检测内容
	public List getPdiCheck(CarSellManageVo carSellManageVo)throws Exception;
	
	//获取PDI历史检测记录
	public Json findFactoryPdiCheck(CarSellManageVo carSellManageVo)throws Exception;
	
	//保存PDI检测内容
	public void savePDI(CarSellManageVo carSellManageVo)throws Exception;
	
	//放弃购车
	public Msg doAabandon(CarSellManageVo carSellManageVo)throws Exception;

	//获取车辆信息
	public Json getCarInfor(CarSellManageVo carSellManageVo)throws Exception;
	
	//获取客户信息
	public Json getcustomInfor(CarSellManageVo carSellManageVo)throws Exception;
	
	//获取指定客户信息
	public CarSellManageVo getCustomInforByCustomId(CarSellManageVo carSellManageVo)throws Exception;
	
	//转结算
	public Boolean doCash(CarSellManageVo carSellManageVo)throws Exception;
	
	//添加客户信息
	public String addOutCustom(CarSellManageVo carSellManageVo)throws Exception;
	
	//转入售后
	public int doSellAfter(CarSellManageVo carSellManageVo)throws Exception;

	
	public XsChilddictionary getCheckResault(int cid)throws Exception;
	// 销售单查询模块，查询父菜单信息功能
	public Datagrid queryFatherInfor(CarSellManageVo carSellManageVo) throws Exception;
	// 销售单查询模块，查询子菜单信息功能
	public List<CarSellManageVo> findChildList(CarSellManageVo carSellManageVo)	throws Exception;

	/**查找销售单相关数据*/
	public CarSellManageVo findContact(CarSellManageVo carSellManageVo)	throws Exception;
	
	/**判断销售单是否放弃购车*/
	public Boolean isBackCar(CarSellManageVo carSellManageVo)	throws Exception;

}

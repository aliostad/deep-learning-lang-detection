package com.syuesoft.sell.sellwork.service;

import java.util.List;

import com.syuesoft.sell.sellwork.vo.QuitCarManageVo;
import com.syuesoft.util.Json;
import com.syuesoft.util.Message;

public interface QuitCarManageService {

	//新增退车信息
	public void addQuitInfor(QuitCarManageVo quitCarManageVo)throws Exception;
	
	//获取退车信息
	public Json getQuitInfor(QuitCarManageVo quitCarManageVo)throws Exception;
	
	//审核退车信息
	public Message doAuditQuitInfor(QuitCarManageVo quitCarManageVo)throws Exception;
	
	//删除退车信息
	public void deleteQuitInfor(QuitCarManageVo quitCarManageVo)throws Exception;
	
	//修改退车信息
	public void updateQuitInfor(QuitCarManageVo quitCarManageVo)throws Exception;
	
	//通知退款
	public Boolean doNoticeRefundment(QuitCarManageVo quitCarManageVo)throws Exception;
	
	//获取该退车单对应的预收、应收款记录
	public QuitCarManageVo getAmountByExit(QuitCarManageVo quitCarManageVo)throws Exception;
	
}

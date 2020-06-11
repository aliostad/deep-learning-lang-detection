package com.szc.fast_express_system.service;

import com.szc.fast_express_system.common.exception.BusinessException;

import android.os.Handler;


/******************************************
 * 类描述： 业务�? 类名称：AppService
 * 
 * @version: 1.0
 * @author: why
 * @time: 2014-2-13 下午2:09:22
 ******************************************/
public interface AppService {
	/** 登陆 **/
	public void login(Handler handler) throws BusinessException;
	public void register(Handler handler) throws BusinessException;
	public void submit(Handler handler)throws BusinessException;
	public void getorder(Handler handler)throws BusinessException; 
	public void getallorder(Handler handler)throws BusinessException; 
	public void sendstate(Handler handler)throws BusinessException;
	public void orderchange(Handler handler)throws BusinessException;
	public void deleteOrder(Handler handler)throws BusinessException;
	public void acceptorder(Handler handler)throws BusinessException;
	
}

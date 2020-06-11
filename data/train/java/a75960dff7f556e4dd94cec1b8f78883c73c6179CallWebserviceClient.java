package com.pishoper.crm.support.client;

import com.pishoper.api.client.channel.ChannelManage;
import com.pishoper.api.client.company.ComManage;
import com.pishoper.api.client.goods.GoodsManage;
import com.pishoper.api.client.*;
import com.pishoper.crm.common.util.DbResource;


/**
 * 获取Webservice调用接口类
 * 
 * @author 10107829
 */
public class CallWebserviceClient {
	
	// webservice服务地址
	private static String address = DbResource.getInstance().getConfig("webserviceaddress");
	
	//权限
	private static ChannelManage channelManage;
	private static GoodsManage goodsManage;
	private static ComManage comManage;
	
	
	/**
	 * 权限管理接口实例
	 * 
	 * @return 权限管理接口实例
	 */
	public static ChannelManage getChannelManage() {
		
		// 获取内容管理接口实例
		if (null == channelManage) {
			// 内容管理接口实例
			channelManage = (ChannelManage) ClientUtil.getService(address, ChannelManage.class);
		}
		return channelManage;
	}
	
	public static GoodsManage getGoodsManage(){
		if (null == goodsManage) {
			// 内容管理接口实例
			goodsManage = (GoodsManage) ClientUtil.getService(address, GoodsManage.class);
		}
		return goodsManage;
	}
	
	public static ComManage getComManage(){
		if (null == comManage) {
			// 内容管理接口实例
			comManage = (ComManage) ClientUtil.getService(address, ComManage.class);
		}
		return comManage;
	}
	
}

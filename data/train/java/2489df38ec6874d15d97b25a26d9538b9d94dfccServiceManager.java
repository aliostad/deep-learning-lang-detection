package com.eethan.ineedu.manager;



import com.eethan.ineedu.service.IMChatService;
import com.eethan.ineedu.service.LocateService;
import com.eethan.ineedu.service.NoticeService;

import android.content.Context;
import android.content.Intent;

public class ServiceManager {

	private Context context;
	public ServiceManager(Context context) {
		// TODO Auto-generated constructor stub
		this.context = context;
	}
	//开启服务
	public void startService(){
		//定位服务
		Intent locateService = new Intent(context, LocateService.class);
		context.startService(locateService);
		
		//聊天的消息服务
		Intent imChatService = new Intent(context, IMChatService.class);
		context.startService(imChatService);
		//通知服务
		Intent noticeService = new Intent(context, NoticeService.class);
		context.startService(noticeService);
	}
	
	//关闭服务
	public void stopService(){
		//关闭定位服务
		// 定位服务
		Intent locateService = new Intent(context, LocateService.class);
		context.stopService(locateService);
		//聊天的消息服务
		Intent imChatService = new Intent(context, IMChatService.class);
		context.stopService(imChatService);
		// 通知服务
		Intent noticeService = new Intent(context, NoticeService.class);
		context.stopService(noticeService);
	}
}

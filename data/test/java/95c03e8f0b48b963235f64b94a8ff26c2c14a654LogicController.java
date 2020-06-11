package com.example.ipcplayer.manager;

import android.content.Context;
import android.os.Handler;

/**
 * UI界面的逻辑控制器
 * 职责：
 * 1.用于与UI和后端组件的交互中间层，将UI所需要的数据发给UI
 * 2.生命周期与Activity相同
 * 3.负责管理所有组件
 * 
 */
public class LogicController{
	/**
	 * 上下文
	 */
	protected Context mContext = null;
	
	/**
	 * 用于回调UI的handler
	 */
	protected Handler mUiHandler = null;
	
	/**
	 * 逻辑控制器构造方法
	 * @param context
	 * @param uiHandler
	 */
	protected LogicController(Context context, Handler uiHandler)
	{
		mContext = context;
		mUiHandler = uiHandler;
	}
	
	public Handler getUiHandler()
	{
		return mUiHandler;
	}
	
	public void setUiHandler(Handler handler)
	{
		mUiHandler = handler;
	}
}
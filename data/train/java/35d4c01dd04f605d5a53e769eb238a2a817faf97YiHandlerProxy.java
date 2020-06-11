package com.ikantech.support.proxy;

import android.content.Context;
import android.os.Handler;
import android.os.Message;

public class YiHandlerProxy
{
	private Context mContext;
	private Handler mHandler;
	private YiHandlerProxiable mHandlerProxiable;

	public YiHandlerProxy(Context context, YiHandlerProxiable handlerProxiable)
	{
		mContext = context;
		mHandlerProxiable = handlerProxiable;
		mHandler = new Handler(mContext.getMainLooper())
		{
			@Override
			public void handleMessage(Message msg)
			{
				processHandlerMessage(msg);
			}
		};
	}

	public void processHandlerMessage(Message msg)
	{
		mHandlerProxiable.processHandlerMessage(msg);
	}

	public Handler getHandler()
	{
		return mHandler;
	}

	public interface YiHandlerProxiable
	{
		void processHandlerMessage(Message msg);

		Handler getHandler();
	}
}

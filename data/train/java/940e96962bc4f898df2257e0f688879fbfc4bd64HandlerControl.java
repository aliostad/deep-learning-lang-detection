package com.example.shareapp.control;


import java.util.ArrayList;

import com.example.shareapp.data.TriggerInfo;

import android.os.Handler;
import android.os.Message;


public class HandlerControl
{
	
	public static HandlerControl handlerControl = null;
	private Handler handler = null;
	private ArrayList<HandlerListener> arrayList = new ArrayList<HandlerListener>();
	
	public static HandlerControl getHandlerControl()
	{
		return handlerControl;
	}
	
	public static HandlerControl getInstance()
	{
		if( handlerControl == null )
		{
			handlerControl = new HandlerControl();
		}
		return handlerControl;
	}
	
	private HandlerControl()
	{
		handler = new Handler() {
			
			@Override
			public void handleMessage(
					Message msg )
			{
				// TODO Auto-generated method stub
				for( HandlerListener handlerListener : arrayList )
				{
					handlerListener.onTrigger( (TriggerInfo)msg.obj );
				}
				super.handleMessage( msg );
			}
		};
	}
	
	public void addHandlerListener(
			HandlerListener handlerListener )
	{
		arrayList.add( handlerListener );
	}
	
	public static interface HandlerListener
	{
		
		void onTrigger(
				TriggerInfo triggerInfo );
	}
	
	
	public void sendTrigger(TriggerInfo triggerInfo){
		Message msg = new Message();
		msg.obj = triggerInfo;
		handler.sendMessage(msg);
	}
}

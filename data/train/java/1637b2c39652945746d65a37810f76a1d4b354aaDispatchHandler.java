package com.vdsp;

import android.os.Handler;
import android.os.Message;

public class DispatchHandler {
	public final static int SHOW_SHORTNOTICE=255;
	public final static int SHOW_LONGNOTICE=254;
	private static Handler handler=null;
	public static Handler setHandler(Handler h){
		if(null!=handler){
			synchronized(handler){
				Handler o=handler;
				handler=h;
				return o;
			}
		}else{
			handler=h;
			return h;
		}
	}
	public static boolean isCurrent(Handler h){
		return h==handler;
	}
	public static Handler getHandler(){
		if(null!=handler){
			synchronized(handler){
				return handler;
			}
		}else{
			return null;
		}
	}
	public static boolean sendMessage(Message msg){
		if(null!=handler){
			synchronized(handler){
				return handler.sendMessage(msg);
			}
		}else{
			return false;
		}
	}
	public static void submitShortNotice(String info){
		if(null!=handler){
			android.os.Message msg = new android.os.Message();
			msg.what=SHOW_SHORTNOTICE;
			msg.obj=info;
			sendMessage(msg);
		}
	}
	public static void submitLongNotice(String info){
		if(null!=handler){
			android.os.Message msg = new android.os.Message();
			msg.what=SHOW_LONGNOTICE;
			msg.obj=info;
			sendMessage(msg);
		}
	}
}

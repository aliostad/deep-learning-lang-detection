package com.jrla.client;

import com.jrla.client.activity_chat.MyHandler;

import android.R.string;
import android.app.Application;
import android.os.Handler;

/**
 * 自己实现Application，实现数据共享
 * 
 * @author jason
 */
public class myapp extends Application {
	// 共享变量
	private static MyHandler handler = null;
	
	// set方法
	public void setHandler(MyHandler handler) {
		this.handler = handler;
	}

	// get方法
	public MyHandler getHandler() {
		return handler;
	}
	
//	public void setHandler(Handler handler) {
//		this.handler = handler;
//	}
//
//	// get方法
//	public Handler getHandler() {
//		return handler;
//	}
	
	private String  chatString=null;
	// set方法
		public void setchat(String str) {
			this.chatString = str;
		}

		// get方法
		public String getchat() {
			return chatString;
		}
}

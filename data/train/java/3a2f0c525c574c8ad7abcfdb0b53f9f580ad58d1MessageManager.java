package com.altamob.ad.appwall.net;

import android.os.Handler;
import android.os.Message;

/**
 * 消息管理
 */
public class MessageManager {

	private Handler handler = null;
	private Object result;

	public MessageManager(Handler handler) {
		this.handler = handler;
	}

	public Handler getHandler() {
		return handler;
	}

	public void setHandler(Handler handler) {
		this.handler = handler;
	}

	public Object getResult() {
		return result;
	}

	private void setResult(Object result) {
		this.result = result;
	}

	public void sendHandlerMessage(int msgid, Object obj) {
		if (handler != null) {
			Message message = new Message();
			message.what = msgid;
			message.obj = obj;
			handler.sendMessage(message);
		}
		setResult(obj);
	}

	public static void sendMessage(Handler handler, int msgid, Object obj) {
		if (handler != null) {
			Message message = handler.obtainMessage();
			message.what = msgid;
			message.obj = obj;
			handler.sendMessage(message);
		}
	}

	public static void sendMessage(Handler handler, int msgid, Object obj, int position) {
		if (handler != null) {
			Message message = handler.obtainMessage();
			message.what = msgid;
			message.obj = obj;
			message.arg1 = position;
			handler.sendMessage(message);
		}
	}
}

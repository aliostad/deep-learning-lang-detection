package net.behoo.appmarket.http;

import android.os.Handler;
import android.os.Message;

public class ProtocolDownloadTask implements Runnable {
	
	private Handler mHandler = null;
	
	public ProtocolDownloadTask(Handler handler) {
		mHandler = handler;
	}
	
	public void setHandler(Handler handler) {
		synchronized (this) {
			mHandler = handler;
		}
	}
	
	public void run() {
		Message msg = new Message();
		msg.what = 
			doTask() ? DownloadConstants.MSG_PROTOCOL_SUCCEED : DownloadConstants.MSG_PROTOCOL_FAILURE;
		
		synchronized (this) {
			if (null != mHandler) {
				mHandler.sendMessage(msg);
			}
		}
	}
	
	protected boolean doTask() {
		return false;
	}
}

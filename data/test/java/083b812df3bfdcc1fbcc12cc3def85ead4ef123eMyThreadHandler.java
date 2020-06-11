package com.example.background;

import android.os.Handler;
import android.os.Message;

public class MyThreadHandler extends Thread {
	
	private Handler myHandler;
	private int delay = 2000;
	boolean shouldContinue = true;
	private int c;
	private Handler myHandlerLoop;

	public MyThreadHandler (Handler handler) {
		myHandler = handler;
		myHandlerLoop = new Handler();
	}
	
	public void run () {
		if (!shouldContinue)
			return;
		
		Message msg = new Message();
		msg.what = c * (delay/1000);
		myHandler.sendMessage(msg);
		
		c = c + 1;
		
		myHandlerLoop.postDelayed(this, delay);
	}
}

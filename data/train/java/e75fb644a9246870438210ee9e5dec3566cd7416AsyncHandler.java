package com.whh.timer.util;

import android.os.Handler;
import android.os.HandlerThread;

/**
 * 使用异步线程进行操作。如程序接收到broadcast(TimerInitReceiver、TimerReceiver)
 * 的时候会使用异步线程进行相应的处理操作
 */
public final class AsyncHandler {
	// 使用HandlerThread类新开线程进行操作
	private static final HandlerThread sHandlerThread = new HandlerThread("AsyncHandler");
	// Handler对象
	private static final Handler sHandler;

	static {
		sHandlerThread.start();// 使用HandlerThread必须调用start()方法
		sHandler = new Handler(sHandlerThread.getLooper());// 初始化Handler对象
	}

	/**
	 * 调用Handler的post()方法
	 */
	public static void post(Runnable r) {
		sHandler.post(r);
	}

	private AsyncHandler() {// 不允许继承
	}
}
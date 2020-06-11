package com.urqa.exceptionhandler;

import com.urqa.library.UncaughtExceptionHandler;

/**
 * @deprecated Use {@link UncaughtExceptionHandler}.
 */
@Deprecated
public class ExceptionHandler implements Thread.UncaughtExceptionHandler {
	
	private UncaughtExceptionHandler mUncaughtExceptionHandler;

	public ExceptionHandler() {
		mUncaughtExceptionHandler = new UncaughtExceptionHandler();
	}

	@Override
	public void uncaughtException(Thread thread, Throwable ex) {
		mUncaughtExceptionHandler.uncaughtException(thread, ex);
	}
}

package com.uva.concurrent;

import android.os.Handler;

public class HandlerScheduler implements AbstractScheduler {
	private final Handler handler;

	public HandlerScheduler(Handler handler) {
		this.handler = handler;
	}

	public void schedule(Runnable target) {
		handler.post(target);
	}

	public void scheduleDelayed(Runnable target, final long delay) {
		handler.postDelayed(target, delay);
	}

	public void scheduleAt(Runnable target, final long atTime) {
		handler.postAtTime(target, atTime);
	}

	public boolean cancel(Runnable target) {
		handler.removeCallbacks(target);

		// FIXME: What can i return?
		return true;
	}
}

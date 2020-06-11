package cn.buding.android.common.asynctask;

import android.content.Context;

/**
 * base task provide success/fail handler.
 */
public abstract class HandlerTask<A, B, C> extends BaseTask<A, B, C> {
	protected MethodHandler<C> successHandler;
	protected MethodHandler<C> failHandler;
	protected MethodHandler<C> finallyHandler;
	private boolean interrupted = false;

	public HandlerTask(Context context) {
		super(context);
	}

	protected void onPostExecute(C result) {
		super.onPostExecute(result);
	}

	public HandlerTask<A, B, C> setOnExecuteSuccessHandler(
			MethodHandler<C> handler) {
		this.successHandler = handler;
		return this;
	}

	public HandlerTask<A, B, C> setOnExecuteFailHander(MethodHandler<C> handler) {
		failHandler = handler;
		return this;
	}

	public HandlerTask<A, B, C> setOnFinallyHander(MethodHandler<C> handler) {
		finallyHandler = handler;
		return this;
	}

	public void interrupt() {
		interrupted = true;
		this.cancel(true);
	}

	public boolean isInterrupt() {
		return interrupted;
	}

	public static interface MethodHandler<T> {
		public void process(T t);
	}
}

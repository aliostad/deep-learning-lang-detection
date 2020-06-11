package com.tianhedaoyun.lgmr.common;

import android.app.Application;
import android.os.Handler;

public class MyApp extends Application {
	private Handler nhandler;

	public void setNhandler(Handler nhandler) {
		this.nhandler = nhandler;
	}

	private Handler handler;

	public Handler getHandler() {
		return this.handler;
	}

	public void onCreate() {
		super.onCreate();
	}

	public void setHandler(final Handler handler) {
		this.handler = handler;
	}

	public Handler getNhandler() {
		// TODO Auto-generated method stub
		return this.nhandler;
	}

}

package com.fqy.fqylibs;

import com.fqy.fqylibs.manage.FQYActivityManage;
import com.lidroid.xutils.BitmapUtils;

import android.app.Application;
import android.content.Context;

public class FQYApplication extends Application {

	protected FQYActivityManage activityManage;

	public static Context appContext;
	

	@Override
	public void onCreate() {
		super.onCreate();

		activityManage = FQYActivityManage.getFQYActivityManage();
		appContext = getApplicationContext();
	}

	public FQYActivityManage getActivityManage() {
		return activityManage;
	}

	public void setActivityManage(FQYActivityManage activityManage) {
		this.activityManage = activityManage;
	}

}

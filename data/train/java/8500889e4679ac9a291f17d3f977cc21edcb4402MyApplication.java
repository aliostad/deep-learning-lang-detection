package com.example.homeservice.base;

import com.example.homeservice.LocManage;
import com.example.homeservice.MapManage;

import android.app.Application;
import android.content.Context;

public class MyApplication extends Application {
	private static MapManage mapManage;
	private static LocManage locManage;
	private static Context mContext;
	@Override
	public void onCreate() {
		mapManage = new MapManage(getApplicationContext());
		locManage = new LocManage(getApplicationContext());
		mContext = getApplicationContext();
		super.onCreate();
	}
	
	public static MapManage getMapManage(){
		return mapManage;
	}
	
	public static LocManage getLocManage(){
		return locManage;
	}

	public static Context getContext() {
		return mContext;
	}
}

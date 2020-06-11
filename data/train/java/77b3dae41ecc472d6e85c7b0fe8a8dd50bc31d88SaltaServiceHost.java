package com.salta.service;

import android.content.ComponentName;
import android.content.Context;
import android.content.ContextWrapper;
import android.content.Intent;
import android.content.ServiceConnection;
import android.os.IBinder;
import android.util.Log;

public class SaltaServiceHost {
	private SaltaService service;

	public SaltaServiceHost(ContextWrapper contextWrapper) {
		ServiceConnection serviceConnection = new ServiceConnection() {
			public void onServiceDisconnected(ComponentName name) {
				Log.d("SaltaServiceHost", "Service Disconnected");
				service = null;
			}

			public void onServiceConnected(ComponentName name, IBinder binder) {
				Log.d("SaltaServiceHost", "Service Connected");
				service = ((SaltaService.SaltaServiceBinder) binder).service();
				ServiceReference.service(service);
			}
		};
		contextWrapper.bindService(new Intent(contextWrapper,
				SaltaService.class), serviceConnection,
				Context.BIND_AUTO_CREATE);
	}

	public SaltaService service() {
		if (service == null) {
			Log.d("SaltaServiceHost", "Service is null");
		}
		return service;
	}
}

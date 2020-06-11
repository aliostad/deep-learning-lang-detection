package com.embraceplus.ble.utils;

import com.embraceplus.utils.Optional;

import android.os.Handler;

public class GlobalHandlerUtil {
	private static GlobalHandlerUtil util = new GlobalHandlerUtil();
	private Optional<Handler> connectActivityHandlerList = new Optional<Handler>();

	private GlobalHandlerUtil() {

	}

	public static GlobalHandlerUtil getInstant() {
		return util;
	}

	public Optional<Handler> getDemoHandler() {
		return connectActivityHandlerList;
	}

	public void setDemoHandler(Handler handler) {
		connectActivityHandlerList = new Optional<Handler>(handler);
	}
}

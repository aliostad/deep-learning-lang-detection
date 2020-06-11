package com.android.sixtopia.citypowerbike.gui;

import com.android.sixtopia.citypowerbike.data.DataHandler;

/**
 * 
 *
 */
public class Initialize{
	
	private static Initialize singleton = null;
	private DataHandler dataHandler;
	
	private Initialize(){
		dataHandler = new DataHandler();
	}
	
	
	public static Initialize getInstance(){
		if(singleton != null) return singleton;
		else {
			singleton = new Initialize();
			return singleton;
		}
	}


	public DataHandler getDataHandler() {
		return dataHandler;
	}

	public void setDataHandler(DataHandler dataHandler) {
		this.dataHandler = dataHandler;
	}
}

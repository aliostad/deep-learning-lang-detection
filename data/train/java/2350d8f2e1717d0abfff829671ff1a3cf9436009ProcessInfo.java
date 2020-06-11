package com.zmy.myphonesafe.domain;

import android.graphics.drawable.Drawable;

/**
 * 进程info
 * 类ProcessInfo.java 
 * @author Administrator 2014-11-23 下午9:33:58
 */
public class ProcessInfo {
    
    //图标
    private  Drawable processIcon;
    
    //名称
    private  String  processName;
    //包名
    private  String  processPackageName;
    //软件大小
    private  String    size;

    
    public Drawable getProcessIcon() {
        return processIcon;
    }

    
    public void setProcessIcon(Drawable processIcon) {
        this.processIcon = processIcon;
    }

    
    public String getProcessName() {
        return processName;
    }

    
    public void setProcessName(String processName) {
        this.processName = processName;
    }

    
    public String getProcessPackageName() {
        return processPackageName;
    }

    
    public void setProcessPackageName(String processPackageName) {
        this.processPackageName = processPackageName;
    }


	
	public String getSize() {
	
		return size;
	}


	public void setSize(String size) {
	
		this.size = size;
	}

  
}

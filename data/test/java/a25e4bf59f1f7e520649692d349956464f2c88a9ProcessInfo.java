package com.yescnc.server.lib.process.manager;

import java.util.Map;

public abstract class ProcessInfo {

	private String processName;
	private String processId;
	private Map processStatus; 

	protected  ProcessInfo(String procName, String procId, Map procStatus) {
		processName = procName;
		processId = procId;
		processStatus = procStatus;	
	}

	public String getProcessName(){
		return processName;
	}

	public void getProcessId(){
		return procId;
	}

	public String getProcessStatus(){
		return processStatus;
	}

	abstract private void saveProcessInfo();
}

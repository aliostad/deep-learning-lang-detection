package com.shine.MultiProcess;

import com.shine.MultiProcess.utils.ProcessUtils;

public class MultiProcessManager {
	private static MultiProcessManager manager = new MultiProcessManager();
	
	private ProcessUtils processUtil=new ProcessUtils();

	public static MultiProcessManager getManager() {
		return manager;
	}

	public void init() {

	}

	public void init(String xmlPath) {

	}

	public void addProcess(String name, String jarPath) {

	}

	public void closeProcess(String name) {

	}

	public void close() {

	}

	public String operaProcess(String name, String commnd) {
		return null;
	}
}

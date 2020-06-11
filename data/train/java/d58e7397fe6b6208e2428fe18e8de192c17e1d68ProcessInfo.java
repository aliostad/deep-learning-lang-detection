package com.tarena.entity;

import java.io.Serializable;

public class ProcessInfo implements Serializable {
	private int processId;
	private String processName;
	private String[] pkgList;

	public int getProcessId() {
		return processId;
	}

	public void setProcessId(int processId) {
		this.processId = processId;
	}

	public String getProcessName() {
		return processName;
	}

	public void setProcessName(String processName) {
		this.processName = processName;
	}

	public String[] getPkgList() {
		return pkgList;
	}

	public void setPkgList(String[] pkgList) {
		this.pkgList = pkgList;
	}

}

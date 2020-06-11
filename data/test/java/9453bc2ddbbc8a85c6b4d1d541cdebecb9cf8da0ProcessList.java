package com.hin.domain;

import java.util.ArrayList;
import java.util.List;

public class ProcessList {

	private String processName;
	private List<String> processIdList = new ArrayList<String>();

	public String getProcessName() {
		return processName;
	}

	public void setProcessName(String processName) {
		this.processName = processName;
	}

	public List<String> getProcessIdList() {
		return processIdList;
	}

	public void setProcessIdList(List<String> processIdList) {
		this.processIdList = processIdList;
	}

	

}

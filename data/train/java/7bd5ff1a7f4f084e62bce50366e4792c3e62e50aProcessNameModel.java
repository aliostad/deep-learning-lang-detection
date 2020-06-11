package com.oasys.viewModel;

public class ProcessNameModel {
	private String processKey;
	private String processName;
	private String listURL;


	
	public ProcessNameModel() {
		super();
		// TODO Auto-generated constructor stub
	}

	public ProcessNameModel(String processKey, String processName,
			String listURL) {
		super();
		this.processKey = processKey;
		this.processName = processName;
		this.listURL = listURL;
	}

	public String getListURL() {
		return listURL;
	}

	public void setListURL(String listURL) {
		this.listURL = listURL;
	}
	
	public String getProcessKey() {
		return processKey;
	}
	public void setProcessKey(String processKey) {
		this.processKey = processKey;
	}
	public String getProcessName() {
		return processName;
	}
	public void setProcessName(String processName) {
		this.processName = processName;
	}
	
}

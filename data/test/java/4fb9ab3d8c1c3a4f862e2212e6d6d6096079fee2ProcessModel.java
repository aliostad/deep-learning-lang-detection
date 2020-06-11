package com.laigaoxing.http.mng;

public class ProcessModel {

	public ProcessModel(){}
	public ProcessModel(String uri,ResponseProcess process){
		this.uri = uri;
		this.process = process;
	}
	int failCount;
	String uri;
	ResponseProcess process;
	public String getUri() {
		return uri;
	}
	public void setUri(String uri) {
		this.uri = uri;
	}
	public ResponseProcess getProcess() {
		return process;
	}
	public void setProcess(ResponseProcess process) {
		this.process = process;
	}
	public int getFailCount() {
		return failCount;
	}
	public void addFailCount(){
		failCount++;
	}

}

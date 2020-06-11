package com.test.wdoctor.network.messageProcess.config;

import java.util.List;

public class MessageProcessConfig {

	private List<MessageProcessBean> processBeans;
	
	public List<MessageProcessBean> getProcessBeans() {
		return processBeans;
	}
	public void setProcessBeans(List<MessageProcessBean> processBeans) {
		this.processBeans = processBeans;
	}
	
	public String getProcessClass(int messageType){
		String processClassName="";
		for(MessageProcessBean bean:processBeans){
			if(messageType==bean.getMessageType()){
				processClassName=bean.getProcessClass();
				break;
			}
		}
		return processClassName;
	}

}

package com.blogspot.nataliprograms.baseandroidapp.events;

import com.blogspot.nataliprograms.baseandroidapp.BaseAppService;


public class ServiceConnectionEvent {

	private BaseAppService chatModuleService;
	
	public ServiceConnectionEvent(BaseAppService chatModuleService) {
		super();
		this.chatModuleService = chatModuleService;
	}

	public BaseAppService getChatModuleService() {
		return chatModuleService;
	}

	public void setChatModuleService(BaseAppService chatModuleService) {
		this.chatModuleService = chatModuleService;
	}

}

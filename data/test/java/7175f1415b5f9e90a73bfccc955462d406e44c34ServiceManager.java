package com.antony.service;

import com.antony.service.local.biz.LocalService;
import com.antony.service.msg.biz.MessageService;
import com.antony.service.party.biz.PartyService;
import com.antony.service.sina.biz.SinaService;
import com.antony.service.user.biz.UserService;

/**
 * @author LH
 * 
 */
public class ServiceManager {

	public static ServiceManager instance;

	public ServiceManager() {
	}

	private UserService userService;
	private PartyService partyService;
	private LocalService localService;
	private SinaService sinaService;
	private MessageService messageService;

	public static ServiceManager getInstance() {
		if (instance == null) {
			instance = new ServiceManager();
		}
		return instance;
	}

	public UserService getUserService() {
		return userService;
	}

	public void setUserService(UserService userService) {
		this.userService = userService;
	}

	public MessageService getMessageService() {
		return messageService;
	}

	public void setMessageService(MessageService messageService) {
		this.messageService = messageService;
	}

	public PartyService getPartyService() {
		return partyService;
	}

	public void setPartyService(PartyService partyService) {
		this.partyService = partyService;
	}

	public LocalService getLocalService() {
		return localService;
	}

	public void setLocalService(LocalService localService) {
		this.localService = localService;
	}

	public SinaService getSinaService() {
		return sinaService;
	}

	public void setSinaService(SinaService sinaService) {
		this.sinaService = sinaService;
	}

}

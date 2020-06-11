package com.sharedissues.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class ServiceSupport {
	
	@Autowired
	PersonReadService personReadService;
	
	@Autowired 
	PersonWriteService personWriteService;
	
	@Autowired
	CommonService commonService;
	public CommonService getCommonService() {
		return commonService;
	}

	public void setCommonService(CommonService commonService) {
		this.commonService = commonService;
	}

	public PersonReadService getPersonReadService() {
		return personReadService;
	}

	public void setPersonReadService(PersonReadService personReadService) {
		this.personReadService = personReadService;
	}

	public PersonWriteService getPersonWriteService() {
		return personWriteService;
	}

	public void setPersonWriteService(PersonWriteService personWriteService) {
		this.personWriteService = personWriteService;
	}

	
	
}

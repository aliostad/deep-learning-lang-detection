package com.ebiz.ssi.service.impl;

import com.ebiz.ssi.service.BaseFacade;
import com.ebiz.ssi.service.MailService;
import com.ebiz.ssi.service.TemplateService;

/**
 * @author Jin,QingHua
 * @version 2009-11-10
 */
public class BaseFacadeImpl implements BaseFacade {

	MailService mailService;

	TemplateService templateService;

	public MailService getMailService() {
		return mailService;
	}

	public void setMailService(MailService mailService) {
		this.mailService = mailService;
	}

	public TemplateService getTemplateService() {
		return templateService;
	}

	public void setTemplateService(TemplateService templateService) {
		this.templateService = templateService;
	}

}

package ssm.core.service.impl;

import ssm.core.service.BaseFacade;
import ssm.core.service.MailService;
import ssm.core.service.TemplateService;

/**
 * @author jinqinghua@gmail.com
 * @version 2012/08/04
 */
public class BaseFacadeImpl implements BaseFacade {

	private MailService mailService;

	private TemplateService templateService;

	public BaseFacadeImpl() {

	}

	@Override
	public MailService getMailService() {
		return mailService;
	}

	public void setMailService(MailService mailService) {
		this.mailService = mailService;
	}

	@Override
	public TemplateService getTemplateService() {
		return templateService;
	}

	public void setTemplateService(TemplateService templateService) {
		this.templateService = templateService;
	}

}

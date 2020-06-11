/**
 * 
 */
package net.freecoder.emailengine;

/**
 * Email Engine contains all the services for email operations.
 * 
 * @author JiTing
 */
public class EmailEngine {

	private EmailService emailService;
	private HistoryService historyService;
	private TemplateService templateService;

	/**
	 * @return the emailService
	 */
	public EmailService getEmailService() {
		return emailService;
	}

	/**
	 * @param emailService
	 *            the emailService to set
	 */
	public void setEmailService(EmailService emailService) {
		this.emailService = emailService;
	}

	/**
	 * @return the historyService
	 */
	public HistoryService getHistoryService() {
		return historyService;
	}

	/**
	 * @param historyService
	 *            the historyService to set
	 */
	public void setHistoryService(HistoryService historyService) {
		this.historyService = historyService;
	}

	/**
	 * @return the templateService
	 */
	public TemplateService getTemplateService() {
		return templateService;
	}

	/**
	 * @param templateService
	 *            the templateService to set
	 */
	public void setTemplateService(TemplateService templateService) {
		this.templateService = templateService;
	}

}

package org.cloudfoundry.support.supportservices.service.job;

import org.cloudfoundry.support.supportservices.repository.SettingsRepository;
import org.cloudfoundry.support.supportservices.repository.TicketRepository;
import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;
import org.springframework.scheduling.quartz.QuartzJobBean;

public class EmailJob extends QuartzJobBean {

	protected SettingsRepository settingsRepository;
	protected TicketRepository ticketRepository;

	public void setSettingsRepository(SettingsRepository settingsRepository) {
		this.settingsRepository = settingsRepository;
	}

	public void setTicketRepository(TicketRepository ticketRepository) {
		this.ticketRepository = ticketRepository;
	}

	@Override
	protected void executeInternal(JobExecutionContext context)
			throws JobExecutionException {
		// left blank for implementing classes
	}

}

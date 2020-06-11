package com.bank.service.internal;

import org.joda.time.LocalTime;

import com.bank.service.TimeService;

public class DefaultTimeService implements TimeService {
	private LocalTime openService;
	private LocalTime closeService;
	

	public DefaultTimeService(LocalTime openService, LocalTime closeService) {
		this.openService = openService;
		this.closeService = closeService;
	}

	@Override
	public boolean isServiceAvailable(LocalTime testTime) {
		return testTime.isAfter(openService) && testTime.isBefore(closeService);
	}

}

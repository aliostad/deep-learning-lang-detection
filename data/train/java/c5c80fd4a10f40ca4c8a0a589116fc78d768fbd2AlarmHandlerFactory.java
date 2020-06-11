package com.basho.proserv.riakmdcmon.Alarm;

import com.basho.proserv.riakmdcmon.Configuration;

public class AlarmHandlerFactory {
	private final Configuration config;
	
	public AlarmHandlerFactory(Configuration config) {
		this.config = config;
	}
	
	public IAlarmHandler create() {
		CompositeHandler handler = new CompositeHandler();
		
		if (config.getConsoleLoggingEnabled()) {
			handler.addHandler(getConsoleHandler());
		}
		if (config.getFileLoggingEnabled()) {
			handler.addHandler(getLogHandler());
		}
		if (config.getSnmpAlarmEnabled()) {
			handler.addHandler(getSnmpHandler());
		}
		
		return handler;
	}
	
	private ConsoleHandler getConsoleHandler() {
		return new ConsoleHandler(config);
	}
	
	private SNMPHandler getSnmpHandler() {
		return new SNMPHandler(config);
	}
	
	private LogHandler getLogHandler() {
		return new LogHandler(config);
	}
}

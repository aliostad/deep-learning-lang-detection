package com.jpattern.core;

import com.jpattern.service.log.ILoggerService;
import com.jpattern.service.log.NullLoggerService;
import com.jpattern.service.log.reader.ILoggerReaderService;
import com.jpattern.service.log.reader.LoggerReaderService;
import com.jpattern.service.log.reader.NullQueueMessages;
import com.jpattern.service.log.slf4j.Slf4jLoggerService;
import com.jpattern.service.mail.IMailService;
import com.jpattern.service.mail.NullMailService;


/**
 * 
 * @author Francesco Cina'
 *
 * 29/gen/2011
 */
public abstract class ASystemProvider implements ISystem {

	private ILoggerService loggerService = new Slf4jLoggerService(new NullLoggerService());
	private IMailService mailService = new NullMailService();
	private ILoggerReaderService loggerReaderService = new LoggerReaderService(new NullQueueMessages());;


    @Override
	public final ILoggerService getLoggerService() {
		return loggerService;
	}

	@Override
	public final IMailService getMailService() {
		return mailService;
	}

    
	@Override
	public ILoggerReaderService getLoggerReaderService() {
		return loggerReaderService;
	}

	@Override
	public void setLoggerReaderServiceBuilder(IServiceBuilder<ILoggerReaderService> loggerReaderServiceBuilder) {
		loggerReaderService = loggerReaderServiceBuilder.buildService();
	}

	@Override
	public void setLoggerServiceBuilder(IServiceBuilder<ILoggerService> loggerServiceBuilder) {
		loggerService = loggerServiceBuilder.buildService();		
	}

	@Override
	public void setMailServiceBuilder(IServiceBuilder<IMailService> mailServiceBuilder) {
		mailService = mailServiceBuilder.buildService();
	}

}

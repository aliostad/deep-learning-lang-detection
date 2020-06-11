package app.cal.schedule.business.centre;

import app.cal.schedule.business.cmd.CommandHandlerFactory;
import app.cal.schedule.business.cmd.HandlerContextFactory;

public class BaseService {

	protected CommandHandlerFactory commandHandlerFactory;
	protected HandlerContextFactory handlerContextFactory;
	
	protected BaseService(CommandHandlerFactory commandHandlerFactory,
			HandlerContextFactory handlerContextFactory){
		
		this.commandHandlerFactory = commandHandlerFactory;
		this.handlerContextFactory = handlerContextFactory;
	}
	
	protected BaseService(){}
}
